require 'json'
require 'socket'
class SigninController < ApplicationController

  before_action :authorize_access_request!, only: [:destroy]
  before_action :set_user, only: [:create]

  def create
    if @user && @user.authenticate(params[:password]) && @company.id == @user.company_id && @user.status == "A"
      @session_records = SessionRecord.find_by!(user_id: @user.id) rescue nil
      if @session_records == nil || @session_records.status == "I"
        payload  = { user_id: @user.id }
        session = JWTSessions::Session.new(payload: payload,
                                            refresh_by_access_allowed: true,
                                            namespace: "user_#{@user.id}")
        tokens = session.login
  
        response.set_cookie(JWTSessions.access_cookie,
                            value: tokens[:access],
                            httponly: true,
                            secure: Rails.env.production?)
  
        update_user_and_device_session_records(@user)
            
        render json: { csrf: tokens[:csrf] }
      else
        info = @user.device_session_records.first
        session_warning(info)
      end

    else
      not_found
    end
  end

  def destroy
    session = JWTSessions::Session.new(payload: payload, namespace: "user_#{payload['user_id']}")
    session.flush_by_access_payload
    update_user_session_upon_logout
    render json: :ok
  end

  private

  def set_user
    @company = Company.find_by!(code: params[:company_code])
    @user = User.find_by!(username: params[:username])
  end

  def update_user_and_device_session_records(user)
    first_create = false

    @record = SessionRecord.where(user_id: user.id).first_or_create do |record|
      record.recent_logged_in = DateTime.now
      record.previous_logged_in = DateTime.now
      record.first_logged_in = DateTime.now
      record.status = "A"
      first_create = true
    end

    if first_create == false
      @record.update({previous_logged_in: @record.recent_logged_in, recent_logged_in: DateTime.now, status: "A"})
    end
    
    ip_address = Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address
    device = user.device_session_records.build({ip_address: ip_address , device_name: Socket.gethostname, os: get_operating_system,  action: "LOGGED IN"})
    device.save!
  end

  def update_user_session_upon_logout
    _user = current_user.session_records.first
    _user.update({status: "I"})
  end

  def get_operating_system
    if request.env['HTTP_USER_AGENT'].downcase.match(/mac/i)
      "Mac"
    elsif request.env['HTTP_USER_AGENT'].downcase.match(/windows/i)
      "Windows"
    elsif request.env['HTTP_USER_AGENT'].downcase.match(/linux/i)
      "Linux"
    elsif request.env['HTTP_USER_AGENT'].downcase.match(/unix/i)
      "Unix"
    else
      "Unknown: #{request.env['HTTP_USER_AGENT']}"
    end
  end

  def not_found
    render json: { error: "Can't find such company, username and password combination" }, status: :not_found
  end

  def session_warning(info)
    render json: { error: "You still have pending session", session_pending: true, recent_activity: {os: info.os, device_name: info.device_name, action: info.action, at: info.created_at}, 
      possible_reason: ["You did not logout your previous session", "someone is currently using this account"]}, status: :unauthorized
  end
end
