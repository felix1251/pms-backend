class Api::V1::CompensationHistoriesController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_compensation_history, only: [:show, :update, :destroy]

  # GET /compensation_histories
  def index
    @compensation_histories = CompensationHistory.all

    render json: @compensation_histories
  end

  # GET /compensation_histories/1
  def show
    render json: @compensation_history
  end

  # POST /compensation_histories
  def create
    @compensation_history = CompensationHistory.new(compensation_history_params)

    if @compensation_history.save
      render json: @compensation_history, status: :created
    else
      render json: @compensation_history.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /compensation_histories/1
  def update
    if @compensation_history.update(compensation_history_params)
      render json: @compensation_history
    else
      render json: @compensation_history.errors, status: :unprocessable_entity
    end
  end

  # DELETE /compensation_histories/1
  def destroy
    @compensation_history.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_compensation_history
      @compensation_history = CompensationHistory.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def compensation_history_params
      params.require(:compensation_history).permit(:employee_id, :description)
    end
end
