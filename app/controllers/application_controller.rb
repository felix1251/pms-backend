require 'socket'
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

  def execute_sql_query(sql)
    ActiveRecord::Base.connection.exec_query(sql)
  end

  def check_backend_session
    _user_session = SessionRecord.find_by!(user_id: payload['user_id'])
    unless Socket.gethostname == _user_session.current_device && get_operating_system == _user_session.current_os && _user_session.status == "A"
      session = JWTSessions::Session.new(payload: payload, namespace: "user_#{payload['user_id']}")
      session.flush_by_access_payload
      render json: {error: "Signed-in in other devices", device: _user_session.current_device, type: "X-DEVICES"}, status: :unauthorized
    end
  end

  def check_page_access(page)
    unless payload["page_access"].include?(page)
      render json: forbidden
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

  def user_page_action_access(user)
    page_action_access = user.user_page_action_accesses
                            .joins("LEFT JOIN page_accesses AS p ON p.id = user_page_action_accesses.page_access_id")  
                            .joins("LEFT JOIN page_action_accesses AS pa ON pa.id = user_page_action_accesses.page_action_access_id") 
                            .select("user_page_action_accesses.*, p.access_code, pa.access_code")
                            .where(status: "A")
                            .pluck("p.access_code, pa.access_code")
                            .map{|e| e.join('')}
  end

  def user_page_action_route(user)
    page_action_access = user.user_page_action_accesses
                            .joins("LEFT JOIN page_accesses AS p ON p.id = user_page_action_accesses.page_access_id")  
                            .select("LOWER(p.page) as route, user_page_action_accesses.status")
                            .where(status: "A")
                            .first
                            .route
                            .parameterize(separator: '-')        
  end

  def ip_address
    Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address rescue "unknown #{request.ip}"
  end

  def host_name
    Socket.gethostname
  end

  def current_user
    @current_user ||= User.joins("LEFT JOIN companies AS c ON c.id = users.company_id")
                          .select("users.id, users.company_id, users.admin, users.email, users.position, users.name,
                                  c.description AS company_name")
                          .find(payload['user_id'])
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
