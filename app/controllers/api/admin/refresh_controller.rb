class Api::Admin::RefreshController < AdministratorsController
  before_action :authorize_refresh_by_access_request!

  def create
    session = JWTSessions::Session.new(payload: claimless_payload,
                                        refresh_by_access_allowed: true,
                                        namespace: "admin_#{claimless_payload['admin_id']}")
    tokens = session.refresh_by_access_payload do
      raise JWTSessions::Errors::Unauthorized, 'Malicious activity detected'
    end

    response.set_cookie(JWTSessions.access_cookie,
                        value: tokens[:access],
                        httponly: true,
                        secure: Rails.env.production?)

    render json: { csrf: tokens[:csrf]}
  end
end
