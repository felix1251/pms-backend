class Api::V1::SalaryModesController < ApplicationController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_salary_mode, only: [:show, :update, :destroy]

  # GET /salary_modes
  def index
    query = "SELECT sm.id as value, sm.description as label FROM salary_modes as sm"
    @salary_modes = execute_sql_query(query)
    render json: @salary_modes
  end

  # # GET /salary_modes/1
  # def show
  #   render json: @salary_mode
  # end

  # # POST /salary_modes
  # def create
  #   @salary_mode = SalaryMode.new(salary_mode_params)

  #   if @salary_mode.save
  #     render json: @salary_mode, status: :created, location: @salary_mode
  #   else
  #     render json: @salary_mode.errors, status: :unprocessable_entity
  #   end
  # end

  # # PATCH/PUT /salary_modes/1
  # def update
  #   if @salary_mode.update(salary_mode_params)
  #     render json: @salary_mode
  #   else
  #     render json: @salary_mode.errors, status: :unprocessable_entity
  #   end
  # end

  # # DELETE /salary_modes/1
  # def destroy
  #   @salary_mode.destroy
  # end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_salary_mode
  #     @salary_mode = SalaryMode.find(params[:id])
  #   end

  #   # Only allow a trusted parameter "white list" through.
  #   def salary_mode_params
  #     params.fetch(:salary_mode, {})
  #   end
end
