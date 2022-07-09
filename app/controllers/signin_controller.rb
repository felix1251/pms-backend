require 'json'
class SigninController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]

  def create
    company = Company.find_by!(code: params[:company_code])
    user = User.find_by!(username: params[:username])

    # if user && company.id != user.company_id
    #   not_found
    # end
    
    if user && user.authenticate(params[:password]) && company.id == user.company_id

      record = SessionRecords.find_by!(user_id: user.id)
      if record.first_logged_in != nil && record.previous_logged_in != nil && record.recent_logged_in != nil 
        record.update({previous_logged_in: user.recent_logged_in, recent_logged_in: DateTime.now})
      else
        record.update({first_logged_in: DateTime.now, previous_logged_in: DateTime.now, recent_logged_in: DateTime.now})
      end

      device = user.device_session_records.build({ip_address: "", device_name:  ""})
      device.save!

      payload  = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload,
                                          refresh_by_access_allowed: true,
                                          namespace: "user_#{user.id}")
      tokens = session.login

      response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access],
                          httponly: true,
                          secure: Rails.env.production?)
                          
      render json: { csrf: tokens[:csrf] }
    else
      not_found
    end
  end

  def destroy
    session = JWTSessions::Session.new(payload: payload, namespace: "user_#{payload['user_id']}")
    session.flush_by_access_payload
    render json: :ok
  end

  private

  def not_found
    render json: { error: "Can't find such company, username and password combination" }, status: :not_found
  end
end
