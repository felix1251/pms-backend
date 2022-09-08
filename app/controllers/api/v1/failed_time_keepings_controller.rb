class Api::V1::FailedTimeKeepingsController < PmsDesktopController
  before_action :set_failed_time_keeping, only: [:show, :update, :destroy]
  before_action :authorize_access_request!
  before_action :check_backend_session

  # GET /failed_time_keepings
  def index
    @failed_time_keepings = FailedTimeKeeping.all

    render json: @failed_time_keepings
  end

  # GET /failed_time_keepings/1
  def show
    render json: @failed_time_keeping
  end

  # POST /failed_time_keepings
  def create
    @failed_time_keeping = FailedTimeKeeping.new(failed_time_keeping_params)

    if @failed_time_keeping.save
      render json: @failed_time_keeping, status: :created, location: @failed_time_keeping
    else
      render json: @failed_time_keeping.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /failed_time_keepings/1
  def update
    if @failed_time_keeping.update(failed_time_keeping_params)
      render json: @failed_time_keeping
    else
      render json: @failed_time_keeping.errors, status: :unprocessable_entity
    end
  end

  # DELETE /failed_time_keepings/1
  def destroy
    @failed_time_keeping.destroy
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
        ['TA']
      when 'update'
        ['TE']
      when 'destroy'
        ['TD']
      else
        ['TV']
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_failed_time_keeping
      @failed_time_keeping = FailedTimeKeeping.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def failed_time_keeping_params
      params.require(:failed_time_keeping).permit(:details)
    end
end
