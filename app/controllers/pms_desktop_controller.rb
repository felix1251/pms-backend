require 'socket'
class PmsDesktopController < ActionController::API
  include JWTSessions::RailsAuthorization
  rescue_from ActionController::ParameterMissing, with: :bad_request
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized
  rescue_from JWTSessions::Errors::ClaimsVerification, with: :forbidden
  rescue_from JWTSessions::Errors::Expired, with: :token_expired
  # rescue_from ResetPasswordError, with: :not_authorized

  private

  def execute_sql_query(sql)
    ActiveRecord::Base.connection.exec_query(sql)
  end


  def check_backend_session
    account = User.find(payload['user_id'])
    _user_session = account.session_record
    unless is_company_active && is_device_allowed && account.status == "A" &&  Socket.gethostname == _user_session.current_device && get_operating_system == _user_session.current_os && _user_session.status == "A"
      session = JWTSessions::Session.new(payload: payload, namespace: "user_#{payload['user_id']}")
      session.flush_by_access_payload
      render json: {error: "Backend session error", device: _user_session.current_device, type: "X-DEVICES"}, status: :unauthorized
    end
  end

  def is_device_allowed
    device = PmsDevice.find_by!(device_id: get_device_id, company_id: payload['company_id']).present? rescue nil
  end

  def is_company_active
    company = Company.find_by!(id: payload['company_id'], status: 'A').present? rescue nil
  end

  def get_device_id
    request.headers['Device-Id']
  end
  
  def custom_pagination(current_page, per_page)
    max = 30
    current_page = current_page || 1
    per_page = per_page || max
    unless per_page <= max
      per_page = max
    end
    return {:fetch_point => (current_page - 1) * per_page, :per_page => per_page} 
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

  def ip_address
    Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address rescue "unknown #{request.ip}"
  end

  def host_name
    Socket.gethostname
  end

  def company_settings
    Company.find(payload['company_id']).settings
  end

  def current_company
    Company.find(payload["company_id"])
  end
  
  def all_access
    all_access = []
    page = PageAccess.order("id ASC").pluck("access_code")
    access = PageActionAccess.order("id ASC").pluck("access_code")
    
    page.each do |pg|
      all_access.push(pg)
      if pg == "H"
        access.each do |ac|
              all_access.push(pg+ac) if ac == "V" 
        end
      elsif pg == "R"
        access.each do |ac|
              all_access.push(pg+ac) if ac == "V" || ac == "X"
        end
      else
        access.each do |ac|
              all_access.push(pg+ac)
        end
      end
    end

    return all_access
  end

  def current_user
    @current_user ||= User.joins("LEFT JOIN companies AS c ON c.id = users.company_id")
                          .select("users.id, users.company_id, users.admin, users.email, users.position, users.name,
                          users.page_accesses, c.logo, c.description AS company_name, c.settings")
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
