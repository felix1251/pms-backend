class Api::V1::UndertimesController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_undertime, only: [:show, :update, :destroy]

  # GET /undertimes
  def index
    @undertimes = Undertime.all

    render json: @undertimes
  end

  # GET /undertimes/1
  def show
    render json: @undertime
  end

  # POST /undertimes
  def create
    @undertime = Undertime.new(undertime_params)

    if @undertime.save
      render json: @undertime, status: :created
    else
      render json: @undertime.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /undertimes/1
  def update
    if @undertime.update(undertime_params)
      render json: @undertime
    else
      render json: @undertime.errors, status: :unprocessable_entity
    end
  end

  # DELETE /undertimes/1
  def destroy
    @undertime.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_undertime
      @undertime = Undertime.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def undertime_params
      params.require(:undertime).permit(:start_time, :end_time, :status, :company_id, :employee_id, :origin, :reason)
    end
end
