class Api::V2::OfficialBusinessesController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :set_official_business, only: [:show, :update, :destroy]

  # GET /official_businesses
  def index
    pagination = custom_pagination(params[:page].to_i, params[:per_page].to_i)
    sql_start = "SELECT"
    sql_count = " COUNT(*) AS total_count"
    sql_fields = " ob.client, ob.reason, ob.status,"
    sql_fields += " CASE WHEN ob.end_date = ob.start_date THEN DATE_FORMAT(ob.start_date, '%b %d, %Y')"
    sql_fields += " ELSE CONCAT(DATE_FORMAT(ob.start_date, '%b %d, %Y'),' - ', DATE_FORMAT(ob.end_date, '%b %d, %Y'))" 
    sql_fields += " END AS date, ob.id, ob.created_at AS date_filed,"
    sql_fields += " (DATEDIFF(ob.end_date, ob.start_date) + 1) as days"
    sql_from = " FROM official_businesses as ob"
    sql_join = " LEFT JOIN employees AS emp ON emp.id = ob.employee_id"
    sql_condition = " WHERE ob.employee_id = #{payload["employee_id"]}"
    sql_sort = " ORDER BY ob.created_at DESC"
    sql_paginate = " LIMIT #{pagination[:per_page]} OFFSET #{pagination[:fetch_point]}"

    ob = execute_sql_query(sql_start + sql_fields + sql_from + sql_join + sql_condition + sql_sort + sql_paginate )
    count = execute_sql_query(sql_start + sql_count + sql_from + sql_condition)
    render json: {data: ob, total_count: count.first["total_count"]}
  end

  # GET /official_businesses/1
  def show
    render json: @official_business
  end

  # POST /official_businesses
  def create
    @official_business = OfficialBusiness.new(official_business_params.merge!({company_id: payload['company_id'], employee_id: payload['employee_id']}))
    if @official_business.save
      render json: @official_business, status: :created
    else
      render json: @official_business.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /official_businesses/1
  def update
    if @official_business.status == "P" && @official_business.update(official_business_params)
      render json: @official_business
    else
      if @official_business.status != "P"
        render json: {error: "Cant't update offset"}, status: :unprocessable_entity
      else
        render json: @official_business.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /official_businesses/1
  def destroy
    if @official_business.status == "P" && @official_business.update(status: "V")
      render json: {message: "Official business voided"}
    else
      if @official_business.status != "P"
        render json: {error: "Cant't void official business"}, status: :unprocessable_entity
      else
        render json: @official_business.errors, status: :unprocessable_entity
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_official_business
      @official_business = OfficialBusiness.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def official_business_params
      params.require(:official_business).permit(:start_date, :end_date, :client, :reason)
    end
end
