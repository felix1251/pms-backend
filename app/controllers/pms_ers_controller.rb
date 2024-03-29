class PmsErsController < ActionController::API
  include JWTSessions::RailsAuthorization
  rescue_from ActionController::ParameterMissing, with: :bad_request
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized
  rescue_from JWTSessions::Errors::ClaimsVerification, with: :forbidden
  rescue_from JWTSessions::Errors::Expired, with: :token_expired
  # rescue_from ResetPasswordError, with: :not_authorized

  private

  def custom_pagination(current_page, per_page)
    max = 30
    current_page = current_page || 1
    per_page = per_page || max
    unless per_page <= max
      per_page = max
    end
    return {:fetch_point => (current_page - 1) * per_page, :per_page => per_page} 
  end

  def employee_company_id
    Employee.select(:company_id).find(payload['employee_id']).company_id rescue nil
  end

  def execute_sql_query(sql)
    ActiveRecord::Base.connection.exec_query(sql)
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
