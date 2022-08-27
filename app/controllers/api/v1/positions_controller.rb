class Api::V1::PositionsController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_position, only: [:show, :update, :destroy]

  # GET /positions
  def index
    sql_start = ""
    sql_start += "SELECT"
    sql_fields = " ps.id value, ps.name AS label, ps.code"
    sql_from = " FROM positions AS ps"
    sql_conditions = " WHERE ps.status = 'A' and company_id = #{payload['company_id']}"
    sql_sort = " ORDER BY ps.name ASC"
    positions = execute_sql_query(sql_start + sql_fields + sql_from + sql_conditions + sql_sort)
    render json: positions
  end

  # GET /positions/1
  def show
    render json: @position
  end

  # POST /positions
  def create
    @position = current_company.positions.new(position_params.merge!({created_by_id: payload['user_id']}))
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
    @position.destroy
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
