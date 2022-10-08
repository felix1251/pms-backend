class Api::Admin::SigninController < AdministratorsController
  before_action :authorize_access_request!, only: [:logout]
  before_action :set_admin, only: [:create]

  def create
    if @admin && @admin.authenticate(params[:password])
      payload = {admin_id: @admin.id, aud: ['admin']}
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true, namespace: "admin_#{@admin.id}")
      tokens = session.login
      response.set_cookie(JWTSessions.access_cookie, value: tokens[:access], httponly: true, secure: Rails.env.production?)
      render json: { csrf: tokens[:csrf], admin: @admin }
    else
      not_found
    end
  end

  def logout
    session = JWTSessions::Session.new(payload: payload, namespace: "admin_#{payload['admin_id']}")
    if session.flush_by_access_payload
      render json: {status: "logout succesfully"}, status: :ok
    end
  end

  private

  def set_admin
    @admin = Administrator.find_by!(username: params[:username])
  end

  def not_found
    render json: { error: "Can't find such username and password combination" }, status: :not_found
  end
end
