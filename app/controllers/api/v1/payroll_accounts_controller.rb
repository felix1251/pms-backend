class Api::V1::PayrollAccountsController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_payroll_account, only: [:show, :update, :destroy]

  # GET /payroll_accounts
  def index
    sql = "SELECT pa.id, cac.name, cac.code, pa.company_account_id, IFNULL(cac.approvers, '[]') as approvers, pa.approved,"
    sql += " pa.approved_by_id, CONCAT(us.name,' (', us.position, ')') AS approved_by"
    sql += " FROM payroll_accounts as pa"
    sql += " LEFT JOIN company_accounts AS cac ON cac.id = pa.company_account_id"
    sql += " LEFT JOIN users AS us ON us.id = pa.approved_by_id"
    sql += " WHERE pa.payroll_id = #{params[:payroll_id]}"
    sql += " ORDER BY cac.name"
    payroll_accounts = execute_sql_query(sql)
    render json: payroll_accounts
  end

  # GET /payroll_accounts/1
  def show
    render json: @payroll_account
  end

  # POST /payroll_accounts
  def create
    @payroll_account = PayrollAccount.new(payroll_account_params)

    if @payroll_account.save
      render json: @payroll_account, status: :created, location: @payroll_account
    else
      render json: @payroll_account.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /payroll_accounts/1
  def update
    if @payroll_account.update(payroll_account_params)
      render json: @payroll_account
    else
      render json: @payroll_account.errors, status: :unprocessable_entity
    end
  end

  # DELETE /payroll_accounts/1
  def destroy
    @payroll_account.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payroll_account
      @payroll_account = PayrollAccount.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def payroll_account_params
      params.require(:payroll_account).permit(:payroll_id, :company_account_id)
    end
end
