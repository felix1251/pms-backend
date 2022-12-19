class Api::Admin::AdminsController < AdministratorsController
  before_action :authorize_access_request!
  before_action :set_admin, only: [:show, :update, :destroy]

  def index
    @admins = Administrator.all
    render json: @admins
  end

  def show
    render json: @admin
  end

  def create
    @admin = Administrator.new(admin_params)
    if @admin.save
      render json: @admin, status: :created
    else
      render json: @admin.errors, status: :unprocessable_entity
    end
  end

  def update
    if @admin.update(admin_params)
      render json: @admin
    else
      render json: @admin.errors, status: :unprocessable_entity
    end
  end

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
    def set_admin
      @admin = Administrator.find(params[:id])
    end

    def admin_params
      params.require(:admin).permit(:username, :password, :password_confirmation, :name)
    end
end
