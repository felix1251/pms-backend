require 'json'
require 'socket'
class SigninController < ApplicationController
  before_action :set_user, only: [:create]
  before_action :authorize_access_request!, only: [:logout]

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
        if params[:cleared].present? && params[:cleared] == true
          clear_session(@user)
        else
          info = @user.device_session_records.first
          session_warning(info) 
        end
      end
    else
      not_found
    end
  end

  def logout
    update_user_session_upon_logout
    session = JWTSessions::Session.new(payload: payload, namespace: "user_#{payload['user_id']}")
    if session.flush_by_access_payload
      render json: {status: "logout succesfully"}, status: :ok
    end
  end

  private

  def clear_session(user)
    _user = SessionRecord.find_by!(user_id: user)
    if _user.update({status: "I"})
      render json: {status: "session cleared, try to signin again."}, status: :ok
    end
  end

  def set_user
    @company = Company.find_by!(code: params[:company_code])
    @user = User.find_by!(username: params[:username])
  end

  def update_user_and_device_session_records(user)
    first_create = false

    ip_address = Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address

    @record = SessionRecord.where(user_id: user.id).first_or_create do |record|
      record.recent_logged_in = DateTime.now
      record.previous_logged_in = DateTime.now
      record.first_logged_in = DateTime.now
      record.current_ip_address = ip_address
      record.current_os = get_operating_system
      record.status = "A"
      record.current_device = Socket.gethostname
      record.sign_in_count += 1
      first_create = true
    end

    if first_create == false
      @record.update({current_ip_address: ip_address, current_os: get_operating_system, previous_logged_in: @record.recent_logged_in, recent_logged_in: DateTime.now, current_device: @record.current_device, status: "A", sign_in_count: @record.sign_in_count+1})
    end
    
    device = user.device_session_records.build({ip_address: @record.current_ip_address , device_name: @record.current_device, os: @record.current_os,  action: "LOGGED IN", at: @record.recent_logged_in})
    device.save!
  end

  def update_user_session_upon_logout
    _user = SessionRecord.find_by!(user_id: current_user.id)
    _user.update({status: "I"})
  end

  def not_found
    render json: { error: "Can't find such company, username and password combination" }, status: :not_found
  end

  def session_warning(info)
    render json: { error: "You still have pending session", session_pending: true, recent_activity: {os: info.os, device_name: info.device_name, action: info.action, at: info.created_at}, 
      possible_reason: ["You did not logout your previous session", "someone is currently using this account"]}, status: :unauthorized
  end
end
