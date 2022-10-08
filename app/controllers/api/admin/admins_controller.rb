class Api::Admin::AdminsController < AdministratorsController
  before_action :authorize_access_request!
  before_action :set_admin, only: [:show, :update, :destroy]

  # GET /admins
  def index
    @admins = Administrator.all
    render json: @admins
  end

  # GET /admins/1
  def show
    render json: @admin
  end

  # POST /admins
  def create
    @admin = Administrator.new(admin_params)
    if @admin.save
      render json: @admin, status: :created
    else
      render json: @admin.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admins/1
  def update
    if @admin.update(admin_params)
      render json: @admin
    else
      render json: @admin.errors, status: :unprocessable_entity
    end
  end

  # DELETE /admins/1
  def destroy
    @admin.destroy
  end

  def token_claims
    {
      aud: ['admin'],
      verify_aud: true
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Administrator.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def admin_params
      params.require(:admin).permit(:username, :password, :password_confirmation, :name)
    end
end
