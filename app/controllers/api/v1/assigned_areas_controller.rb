class Api::V1::AssignedAreasController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_assigned_area, only: [:show, :update, :destroy]

  # GET /assigned_areas
  def index
    sql_start = ""
    sql_start += "SELECT"
    sql_fields = " aa.id value, aa.name AS label, aa.code"
    sql_from = " FROM assigned_areas AS aa"
    sql_conditions = " WHERE aa.status = 'A' and aa.company_id = #{payload['company_id']}"
    sql_sort = " ORDER BY aa.name ASC"
    assigned_areas = execute_sql_query(sql_start + sql_fields + sql_from + sql_conditions + sql_sort)
    render json: assigned_areas
  end

  # GET /assigned_areas/1
  def show
    render json: @assigned_area
  end

  # POST /assigned_areas
  def create
    @assigned_area = AssignedArea.new(assigned_area_params.merge!({company_id: payload["company_id"] ,created_by_id: payload['user_id']}))
    if @assigned_area.save
      render json: @assigned_area, status: :created
    else
      render json: @assigned_area.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /assigned_areas/1
  def update
    if @assigned_area.update(assigned_area_params)
      render json: @assigned_area
    else
      render json: @assigned_area.errors, status: :unprocessable_entity
    end
  end

  # DELETE /assigned_areas/1
  def destroy
    @assigned_area.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assigned_area
      @assigned_area = AssignedArea.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def assigned_area_params
      params.require(:assigned_area).permit(:name, :code)
    end
end
