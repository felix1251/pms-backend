class UserPageAccessesController < ApplicationController
  before_action :set_user_page_access, only: [:show, :update, :destroy]

  # GET /user_page_accesses
  def index
    @user_page_accesses = UserPageAccess.all

    render json: @user_page_accesses
  end

  # GET /user_page_accesses/1
  def show
    render json: @user_page_access
  end

  # POST /user_page_accesses
  def create
    @user_page_access = UserPageAccess.new(user_page_access_params)

    if @user_page_access.save
      render json: @user_page_access, status: :created, location: @user_page_access
    else
      render json: @user_page_access.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_page_accesses/1
  def update
    if @user_page_access.update(user_page_access_params)
      render json: @user_page_access
    else
      render json: @user_page_access.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_page_accesses/1
  def destroy
    @user_page_access.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_page_access
      @user_page_access = UserPageAccess.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_page_access_params
      params.fetch(:user_page_access, {})
    end
end
