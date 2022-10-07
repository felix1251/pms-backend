require 'socket'
class Api::V1::SigninController < PmsDesktopController
  before_action :authorize_access_request!, only: [:logout]
  before_action :set_user, only: [:create]

  def create
    if @user && @user.authenticate(params[:password]) && @company.id == @user.company_id && @user.status == "A"
      @session_records = SessionRecord.find_by!(user_id: @user.id) rescue nil
      if @session_records == nil || @session_records.status == "I"
        payload  = {  user_id: @user.id, 
                      company_id: @user.company_id,
                      admin: @user.admin,
                      aud: user_page_action_access(@user)
                    }
        session = JWTSessions::Session.new(payload: payload,
                                            refresh_by_access_allowed: true,
                                            namespace: "user_#{@user.id}")
        tokens = session.login
        response.set_cookie(JWTSessions.access_cookie,
                            value: tokens[:access],
                            httponly: true,
                            secure: Rails.env.production?)

        update_user_and_device_session_records(@user)

        render json: { csrf: tokens[:csrf], access: tokens[:access]}
      else
        if params[:cleared].present? && params[:cleared] == true
          clear_session(@user)
        else
          session_warning(@user) 
        end
      end
    else
      if @user.status == "I"
        render json: {error: 'This account is disabled '}, status: :unprocessable_entity
      else
        not_found
      end
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
    _user = SessionRecord.find_by!(user_id: user.id)
    user.device_session_records.build({ip_address: ip_address, device_id: get_device_id,
                                      device_name: host_name, os: get_operating_system, 
                                      action: "SESSION CLEARED", at: DateTime.now}).save!
    if _user.update({status: "I"})
      render json: {status: "Session cleared, try to Sign In again."}, status: :ok
    end
  end

  def set_user
    @company = Company.find_by!(code: params[:company_code])
    @user = @company.users.find_by!(username: params[:username])
  end

  def update_user_and_device_session_records(user)
    first_create = false

    @record = SessionRecord.where(user_id: user.id).first_or_create do |record|
      record.recent_logged_in = DateTime.now
      record.previous_logged_in = DateTime.now
      record.first_logged_in = DateTime.now
      record.current_ip_address = ip_address
      record.current_os = get_operating_system
      record.status = "A"
      record.current_device = host_name
      record.current_device_id = get_device_id
      record.sign_in_count += 1
      first_create = true
    end

    if first_create == false
      @record.update({current_ip_address: ip_address, current_os: get_operating_system,
                    previous_logged_in: @record.recent_logged_in, recent_logged_in: DateTime.now, 
                    current_device: host_name, current_device_id: get_device_id, status: "A", 
                    sign_in_count: @record.sign_in_count+1})
    end
    
    device = user.device_session_records.build({ip_address: @record.current_ip_address, 
                                              device_name: @record.current_device, os: @record.current_os, 
                                              device_id: @record.current_device_id, action: "SIGNED IN",
                                              at: @record.recent_logged_in})
    device.save!
  end

  def update_user_session_upon_logout
    _user = SessionRecord.find_by!(user_id: payload["user_id"])
    _user.update({status: "I"})
    current_user.device_session_records.build({ip_address: ip_address, device_id: get_device_id,
                                              device_name: host_name, os: get_operating_system, 
                                              action: "SIGNED OUT", at: DateTime.now}).save!
  end

  def not_found
    render json: { error: "Can't find such company, username and password combination" }, status: :not_found
  end

  def session_warning(user)
    info = user.device_session_records.where("action = 'SIGNED IN'").first
    user.device_session_records.build({ip_address: ip_address, device_id: get_device_id,
                                      device_name: host_name, os: get_operating_system, 
                                      action: "SIGN IN ATTEMPT ON PENDING SESSION", at: DateTime.now}).save!

    render json: { error: "You still have pending session", session_pending: true, current_ip_address: ip_address, current_os: get_operating_system,
                  current_device: host_name, recent_activity: {os: info.os, device_name: info.device_name, action: info.action, at: info.at}, 
                  possible_reason: ["You did not logout your previous session", "someone is currently using this account in other devices"]}, status: :unauthorized
  end
end
