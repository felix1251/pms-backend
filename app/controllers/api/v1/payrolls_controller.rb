class Api::V1::PayrollsController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_payroll, only: [:show, :update, :destroy]

  # GET /payrolls
  def index
    sql = "SELECT py.id, CONCAT(py.from, ' to ', py.to) as date_range, py.from, py.to,"
    sql += " CASE WHEN py.status = 'P' THEN 'pending' WHEN py.status = 'V' THEN 'voided' ELSE 'approved' END as status,"
    sql += " CASE WHEN py.require_approver = true THEN u.name ELSE 'none' END as approver" 
    sql += " FROM payrolls as py"
    sql += " LEFT JOIN users as u ON u.id = py.approver_id"
    sql += " WHERE py.company_id = #{payload['company_id']} and py.status != 'V'"
  
    payrolls = execute_sql_query(sql)
    render json: payrolls
  end

  def approver_list
    sql = "SELECT"
    sql += " id as value, CONCAT(name, ' (',position,')') as label"
    sql += " FROM users"
    sql += " WHERE admin = true AND company_id = #{payload['company_id']}"
    approver = execute_sql_query(sql)
    render json: approver
  end

  # GET /payrolls/1
  def show
    render json: @payroll
  end

  # POST /payrolls
  def create
    @payroll = Payroll.new(payroll_params.merge!({company_id: payload["company_id"]}))
    if @payroll.save
      render json: @payroll, status: :created
    else
      render json: @payroll.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /payrolls/1
  def update
    if @payroll.update(payroll_params)
      render json: @payroll
    else
      render json: @payroll.errors, status: :unprocessable_entity
    end
  end

  # DELETE /payrolls/1
  def destroy
    @payroll.destroy
  end

  def token_claims
    {
      aud: allowed_aud,
      verify_aud: true
    }
  end

  private

    def allowed_aud
      case action_name 
      when 'create'
        ['PA']
      when 'update'
        ['PE']
      when 'destroy'
        ['PD']
      else
        ['PV']
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_payroll
      @payroll = Payroll.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def payroll_params
      params.require(:payroll).permit(:from, :to, :approver_id, :require_approver, :remarks, :pay_date)
    end
end
