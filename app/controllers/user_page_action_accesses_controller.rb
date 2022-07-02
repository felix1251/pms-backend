class UserPageActionAccessesController < ApplicationController
  before_action :set_user_page_action_access, only: [:show, :update, :destroy]

  # GET /user_page_action_accesses
  def index
    @user_page_action_accesses = UserPageActionAccess.all

    render json: @user_page_action_accesses
  end

  # GET /user_page_action_accesses/1
  def show
    render json: @user_page_action_access
  end

  # POST /user_page_action_accesses
  def create
    @user_page_action_access = UserPageActionAccess.new(user_page_action_access_params)

    if @user_page_action_access.save
      render json: @user_page_action_access, status: :created, location: @user_page_action_access
    else
      render json: @user_page_action_access.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_page_action_accesses/1
  def update
    if @user_page_action_access.update(user_page_action_access_params)
      render json: @user_page_action_access
    else
      render json: @user_page_action_access.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_page_action_accesses/1
  def destroy
    @user_page_action_access.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_page_action_access
      @user_page_action_access = UserPageActionAccess.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_page_action_access_params
      params.fetch(:user_page_action_access, {})
    end
end
