class Api::Admin::SocialSecuritySystemsController < AdministratorsController
  before_action :set_social_security_system, only: [:show, :update, :destroy]

  # GET /social_security_systems
  def index
    @social_security_systems = SocialSecuritySystem.all

    render json: @social_security_systems
  end

  # GET /social_security_systems/1
  def show
    render json: @social_security_system
  end

  # POST /social_security_systems
  def create
    @social_security_system = SocialSecuritySystem.new(social_security_system_params)

    if @social_security_system.save
      render json: @social_security_system, status: :created, location: @social_security_system
    else
      render json: @social_security_system.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /social_security_systems/1
  def update
    if @social_security_system.update(social_security_system_params)
      render json: @social_security_system
    else
      render json: @social_security_system.errors, status: :unprocessable_entity
    end
  end

  # DELETE /social_security_systems/1
  def destroy
    @social_security_system.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_social_security_system
      @social_security_system = SocialSecuritySystem.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def social_security_system_params
      params.require(:social_security_system).permit(:com_from, :com_to, :employe_compensation, :mandatory_fund, :salary_credit_total, :rss_er, :rss_ee, :rss_total, :ec_er, :ec_ee, :ec_total, :mpf_er, :mpf_ee, :mpf_total, :total_er, :total_ee, :final_total)
    end
end
