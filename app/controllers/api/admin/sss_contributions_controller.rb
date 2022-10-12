class Api::V1::SssContributionsController < AdministratorsController
  before_action :set_sss_contribution, only: [:show, :update, :destroy]

  # GET /sss_contributions
  def index
    @sss_contributions = SssContribution.all

    render json: @sss_contributions
  end

  # GET /sss_contributions/1
  def show
    render json: @sss_contribution
  end

  # POST /sss_contributions
  def create
    @sss_contribution = SssContribution.new(sss_contribution_params)

    if @sss_contribution.save
      render json: @sss_contribution, status: :created, location: @sss_contribution
    else
      render json: @sss_contribution.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sss_contributions/1
  def update
    if @sss_contribution.update(sss_contribution_params)
      render json: @sss_contribution
    else
      render json: @sss_contribution.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sss_contributions/1
  def destroy
    @sss_contribution.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sss_contribution
      @sss_contribution = SssContribution.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sss_contribution_params
      params.require(:sss_contribution).permit(:title, :status)
    end
end
