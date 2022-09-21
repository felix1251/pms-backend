class Api::V1::OfficialBusinessesController < PmsDesktopController
  before_action :set_official_business, only: [:show, :update, :destroy]

  # GET /official_businesses
  def index
    @official_businesses = OfficialBusiness.all

    render json: @official_businesses
  end

  # GET /official_businesses/1
  def show
    render json: @official_business
  end

  # POST /official_businesses
  def create
    @official_business = OfficialBusiness.new(official_business_params)

    if @official_business.save
      render json: @official_business, status: :created
    else
      render json: @official_business.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /official_businesses/1
  def update
    if @official_business.update(official_business_params)
      render json: @official_business
    else
      render json: @official_business.errors, status: :unprocessable_entity
    end
  end

  # DELETE /official_businesses/1
  def destroy
    @official_business.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_official_business
      @official_business = OfficialBusiness.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def official_business_params
      params.require(:official_business).permit(:start_date, :end_date, :client, :reason, :origin)
    end
end
