class Api::Admin::PmsDevicesController < AdministratorsController
  before_action :authorize_access_request!
  before_action :set_pms_device, only: [:show, :update, :destroy]

  # GET /pms_devices
  def index
    sql = "SELECT"
    sql += " pd.id, pd.allowed, pd.device_id, pd.device_name, com.description AS company_name,"
    sql += " DATE_FORMAT(pd.created_at, '%b %d, %Y %h:%i %p') AS created_at"
    sql += " FROM pms_devices pd"
    sql += " LEFT JOIN companies AS com ON com.id = pd.company_id"

    pms_devices = execute_sql_query(sql)
    render json: pms_devices
  end

  # GET /pms_devices/1
  def show
    render json: @pms_device
  end

  # POST /pms_devices
  def create
    @pms_device = PmsDevice.new(pms_device_params)

    if @pms_device.save
      render json: @pms_device, status: :created, location: @pms_device
    else
      render json: @pms_device.errors, status: :unprocessable_entity
    end
  end

  def token_claims
    {
      aud: ['admin'],
      verify_aud: true
    }
  end

  # PATCH/PUT /pms_devices/1
  def update
    if @pms_device.update(pms_device_params)
      render json: @pms_device
    else
      render json: @pms_device.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pms_devices/1
  def destroy
    @pms_device.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pms_device
      @pms_device = PmsDevice.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def pms_device_params
      params.require(:pms_device).permit(:company_id, :device_id, :device_name)
    end
end
