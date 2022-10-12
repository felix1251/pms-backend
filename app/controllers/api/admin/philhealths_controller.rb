class Api::Admin::PhilhealthsController < AdministratorsController
  before_action :authorize_access_request!
  before_action :set_philhealth, only: [:show, :update, :destroy]

  # GET /philhealths
  def index
    @philhealths = Philhealth.all

    render json: @philhealths
  end

  # GET /philhealths/1
  def show
    render json: @philhealth
  end

  # POST /philhealths
  def create
    @philhealth = Philhealth.new(philhealth_params)

    if @philhealth.save
      render json: @philhealth, status: :created, location: @philhealth
    else
      render json: @philhealth.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /philhealths/1
  def update
    if @philhealth.update(philhealth_params)
      render json: @philhealth
    else
      render json: @philhealth.errors, status: :unprocessable_entity
    end
  end

  # DELETE /philhealths/1
  def destroy
    @philhealth.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_philhealth
      @philhealth = Philhealth.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def philhealth_params
      params.require(:philhealth).permit(:percentage_deduction, :title)
    end
end
