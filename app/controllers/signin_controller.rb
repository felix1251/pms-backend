require 'json'
class SigninController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]

  def create
    company = Company.find_by!(code: params[:company_code])
    user = User.find_by!(username: params[:username])

    if user && company.id != user.company_id
      not_found
    end
    
    if user.authenticate(params[:password])
      page_access_rigths = JSON.parse(user.page_access_rigths)
      action_access_rigths = JSON.parse(user.action_access_rigths)
      
      payload  = { user_id: user.id, page_aud: page_access_rigths, action_aud: action_access_rigths }
      session = JWTSessions::Session.new(payload: payload,
                                          refresh_by_access_allowed: true,
                                          namespace: "user_#{user.id}")
      tokens = session.login

      response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access],
                          httponly: true,
                          # expires: 1.hour.from_now,
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
