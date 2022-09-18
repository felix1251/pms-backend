class Api::V1::LeavesController < PmsDesktopController
  before_action :set_leafe, only: [:show, :update, :destroy]

  # GET /leaves
  def index
    @leaves = Leave.all

    render json: @leaves
  end

  # GET /leaves/1
  def show
    render json: @leafe
  end

  # POST /leaves
  def create
    @leafe = Leave.new(leafe_params)

    if @leafe.save
      render json: @leafe, status: :created, location: @leafe
    else
      render json: @leafe.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /leaves/1
  def update
    if @leafe.update(leafe_params)
      render json: @leafe
    else
      render json: @leafe.errors, status: :unprocessable_entity
    end
  end

  # DELETE /leaves/1
  def destroy
    @leafe.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leafe
      @leafe = Leave.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def leafe_params
      params.require(:leafe).permit(:start_date, :end_date, :leave_type, :reason, :status)
    end
end
