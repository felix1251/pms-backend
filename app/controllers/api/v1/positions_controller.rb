class Api::V1::PositionsController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_position, only: [:show, :update, :destroy]

  # GET /positions
  def index
    sql_start = ""
    sql_start += "SELECT"
    sql_fields = " ps.id value, ps.name AS label, ps.code, ps.created_at"
    sql_from = " FROM positions AS ps"
    sql_conditions = " WHERE ps.status = 'A' and ps.company_id = #{payload['company_id']}"
    sql_sort = " ORDER BY ps.name ASC"

    if params[:page].present? && params[:per_page].present?
      pagination = custom_pagination(params[:page].to_i, params[:per_page].to_i)

      sql_employee_count = " ,(SELECT COUNT(*) FROM employees as emp WHERE ps.id = emp.position_id and emp.status = 'A') AS employee_count" 
      sql_paginate = " LIMIT #{pagination[:per_page]} OFFSET #{pagination[:fetch_point]}"
      sql_count = " COUNT(*) as total_count"

      positions = execute_sql_query(sql_start + sql_fields + sql_employee_count + sql_from + sql_conditions + sql_sort + sql_paginate)
      counts = execute_sql_query(sql_start + sql_count + sql_from + sql_conditions)

      render json: {results: positions, total_count: counts.first["total_count"] }
    else
      positions = execute_sql_query(sql_start + sql_fields + sql_from + sql_conditions + sql_sort)
      render json: positions
    end
  end

  # GET /positions/1
  def show
    render json: @position
  end

  # POST /positions
  def create
    @position = Position.new(position_params.merge!({company_id: payload["company_id"], created_by_id: payload['user_id']}))
    if @position.save
      render json: @position, status: :created
    else
      render json: @position.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /positions/1
  def update
    if @position.update(position_params)
      render json: @position
    else
      render json: @position.errors, status: :unprocessable_entity
    end
  end

  # DELETE /positions/1
  def destroy
    if Employee.where(position_id: @position.id).count > 0
      @position.update(status: "I")
    else
      @position.destroy
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position
      @position = Position.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def position_params
      params.require(:position).permit(:name, :code)
    end
end
