class Api::V1::OfficialBusinessesController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_official_business, only: [:show, :update, :destroy, :ob_action]

  # GET /official_businesses
  def index
    pagination = custom_pagination(params[:page].to_i, params[:per_page].to_i)
    sql_start = "SELECT"
    sql_count = " COUNT(*) AS total_count"
    sql_fields = " ob.client, ob.reason, ob.status,"
    sql_fields += " CASE ob.origin WHEN 0 THEN 'PMS' ELSE 'ERS' END AS origin,"
    sql_fields += " CASE WHEN ob.end_date = ob.start_date THEN end_date"
    sql_fields += " ELSE CONCAT(ob.start_date,',',ob.end_date)" 
    sql_fields += " END AS date, ob.id, ob.created_at AS date_filed,"
    sql_fields += " (DATEDIFF(ob.end_date, ob.start_date) + 1) as days,"
    sql_fields += " CONCAT(emp.last_name, ', ', emp.first_name, ' ', CASE WHEN emp.suffix = '' THEN '' ELSE CONCAT(emp.suffix, '.') END,' ',"
    sql_fields += " CASE emp.middle_name WHEN '' THEN '' ELSE CONCAT(SUBSTR(emp.middle_name, 1, 1), '.') END) AS fullname"
    sql_from = " FROM official_businesses as ob"
    sql_join = " LEFT JOIN employees AS emp ON emp.id = ob.employee_id"
    sql_condition = " WHERE ob.status != 'P'"
    sql_sort = " ORDER BY ob.created_at DESC"
    sql_paginate = " LIMIT #{pagination[:per_page]} OFFSET #{pagination[:fetch_point]}"
    ob = execute_sql_query(sql_start + sql_fields + sql_from + sql_join + sql_condition + sql_sort + sql_paginate )
    count = execute_sql_query(sql_start + sql_count + sql_from + sql_condition)
    render json: {data: ob, total_count: count.first["total_count"]}
  end

  def pending_ob
    pagination = custom_pagination(params[:page].to_i, params[:per_page].to_i)
    sql_start = "SELECT"
    sql_count = " COUNT(*) AS total_count"
    sql_fields = " ob.client, ob.reason, ob.status,"
    sql_fields += " CASE ob.origin WHEN 0 THEN 'PMS' ELSE 'ERS' END AS origin,"
    sql_fields += " CASE WHEN ob.end_date = ob.start_date THEN end_date"
    sql_fields += " ELSE CONCAT(ob.start_date,',',ob.end_date)" 
    sql_fields += " END AS date, ob.id, ob.created_at AS date_filed,"
    sql_fields += " (DATEDIFF(ob.end_date, ob.start_date) + 1) as days,"
    sql_fields += " CONCAT(emp.last_name, ', ', emp.first_name, ' ', CASE WHEN emp.suffix = '' THEN '' ELSE CONCAT(emp.suffix, '.') END,' ',"
    sql_fields += " CASE emp.middle_name WHEN '' THEN '' ELSE CONCAT(SUBSTR(emp.middle_name, 1, 1), '.') END) AS fullname"
    sql_from = " FROM official_businesses as ob"
    sql_join = " LEFT JOIN employees AS emp ON emp.id = ob.employee_id"
    sql_condition = " WHERE ob.status = 'P'"
    sql_sort = " ORDER BY ob.created_at DESC"
    sql_paginate = " LIMIT #{pagination[:per_page]} OFFSET #{pagination[:fetch_point]}"
    ob = execute_sql_query(sql_start + sql_fields + sql_from + sql_join + sql_condition + sql_sort + sql_paginate )
    count = execute_sql_query(sql_start + sql_count + sql_from + sql_condition)
    render json: {data: ob, total_count: count.first["total_count"]}
  end

  def ob_count
    com_id = payload['company_id']
    sql = "SELECT"
    sql += " (SELECT COUNT(*) FROM official_businesses WHERE status = 'P' AND company_id = #{com_id}) as pending,"
    sql += " (SELECT COUNT(*) FROM official_businesses WHERE status = 'A' AND company_id = #{com_id}) as approved,"
    sql += " (SELECT COUNT(*) FROM official_businesses WHERE status = 'D' AND company_id = #{com_id}) as rejected,"
    sql += " (SELECT COUNT(*) FROM official_businesses WHERE status = 'V' AND company_id = #{com_id}) as voided"
    counts = execute_sql_query(sql)
    render json: counts.first
  end

  # GET /official_businesses/1
  def show
    render json: @official_business
  end

  # POST /official_businesses
  def create
    @official_business = OfficialBusiness.new(official_business_params.merge!({company_id: payload['company_id']}))
    if @official_business.save
      render json: @official_business, status: :created
    else
      render json: @official_business.errors, status: :unprocessable_entity
    end
  end

  def ob_action
    if @official_business.update(action_params.merge!({actioned_by_id: payload['user_id']}))
      render json: @official_business
    else
      render json: @official_business.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /official_businesses/1
  def update
    if @official_business.update(official_business_params)
      render json: @official_business
    else
      render json: @official_business.errors, status: :unprocessable_entity
    end
  end

  # DELETE /official_businesses/1
  def destroy
    @official_business.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_official_business
      @official_business = OfficialBusiness.find(params[:id])
    end

    def action_params
      params.require(:official_business).permit(:status)
    end

    # Only allow a trusted parameter "white list" through.
    def official_business_params
      params.require(:official_business).permit(:employee_id,:start_date, :end_date, :client, :reason)
    end
end
