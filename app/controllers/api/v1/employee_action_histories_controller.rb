class Apis::V1::EmployeeActionHistoriesController < PmsDesktopController
  before_action :set_employee_action_history, only: [:show, :update, :destroy]

  # GET /employee_action_histories
  def index
    @employee_action_histories = EmployeeActionHistory.all

    render json: @employee_action_histories
  end

  # GET /employee_action_histories/1
  def show
    render json: @employee_action_history
  end

  # POST /employee_action_histories
  def create
    @employee_action_history = EmployeeActionHistory.new(employee_action_history_params)

    if @employee_action_history.save
      render json: @employee_action_history, status: :created
    else
      render json: @employee_action_history.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /employee_action_histories/1
  def update
    if @employee_action_history.update(employee_action_history_params)
      render json: @employee_action_history
    else
      render json: @employee_action_history.errors, status: :unprocessable_entity
    end
  end

  # DELETE /employee_action_histories/1
  def destroy
    @employee_action_history.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee_action_history
      @employee_action_history = EmployeeActionHistory.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def employee_action_history_params
      params.require(:employee_action_history).permit(:action_by_id, :employee_id, :action_type)
    end
end
