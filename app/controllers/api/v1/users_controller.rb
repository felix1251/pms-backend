require 'json'
class Api::V1::UsersController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_user, only: [:update, :destroy, :retrieve_archived_account]

  def create
    company = Company.find(payload["company_id"])
    @user = company.users.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if !@user.system_default && @user.id != payload["user_id"]
      if @user.update(status: "I")
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: {error: "can't delete, user is default or current user"}, status: :forbidden
    end
  end

  def retrieve_archived_account
    if !@user.system_default
      if @user.update(status: "A")
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: {error: "can't modify, user is default"}, status: :forbidden
    end
  end

  def get_account
    @account = User.select("id, company_id, admin, email, position, system_default,
                          name, status, created_at, username, page_accesses")
                          .find(params[:id])

    render json: {account: @account}
  end

  def system_accounts
    max_per_page = 13
    page = params[:page].to_i
    per_page = params[:per_page].to_i

    if per_page > max_per_page
      per_page = max_per_page
    end

    accounts = User.paginate(:page => page, :per_page => per_page)
                    .select("id, company_id, admin, email, position, system_default,
                      name, status, DATE(created_at) AS created")
                    .where(company_id: payload['company_id'], status: "A")
                    
    render json: {accounts: accounts, count: accounts.count} 
  end

  def archived_accounts
    max_per_page = 13
    page = params[:page].to_i
    per_page = params[:per_page].to_i

    if per_page > max_per_page
      per_page = max_per_page
    end

    accounts = User.paginate(:page => page, :per_page => per_page)
                    .select("id, company_id, admin, email, position, system_default,
                      name, status, DATE(created_at) AS created")
                    .where(company_id: payload['company_id'], status: "I")
                    
    render json: {accounts: accounts, count: accounts.count} 
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
      ['YA']
    when 'update' , 'retrieve_archived_account'
      ['YE']
    when 'destroy'
      ['YD']
    else
      ['YV']
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :position, :username, :admin, :password, :password_confirmation, :page_accesses => [])
  end

  def set_user
    @user = User.find(params[:id])
  end
end
