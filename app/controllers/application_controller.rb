class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization
  rescue_from ActionController::ParameterMissing, with: :bad_request
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized
  rescue_from JWTSessions::Errors::ClaimsVerification, with: :forbidden
  rescue_from JWTSessions::Errors::Expired, with: :token_expired
  rescue_from ResetPasswordError, with: :not_authorized

  private

  def check_backend_session
    _user_session = SessionRecord.find_by!(user_id: current_user.id)
    ip_address = Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address 
    unless Socket.gethostname == _user_session.current_device && get_operating_system == _user_session.current_os
      session = JWTSessions::Session.new(payload: payload, namespace: "user_#{payload['user_id']}")
      session.flush_by_access_payload
      render json: {error: "X-DEVICES"}, status: :unauthorized
    end
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

  def current_user
    @current_user ||= User.find(payload['user_id'])
  end

  def bad_request
    render json: { error: 'Bad request' }, status: :bad_request
  end

  def forbidden
    render json: { error: 'Forbidden' }, status: :forbidden
  end

  def not_authorized
    render json: { error: 'Not authorized' }, status: :unauthorized
  end

  def not_found
    render json: { error: 'Not found' }, status: :not_found
  end

  def token_expired
    render json: { error: 'Token expired' }, status: :unauthorized
  end

  def unprocessable_entity(exception)
    render json: { error: exception.record.errors.full_messages.join(' ') }, status: :unprocessable_entity
  end
end
