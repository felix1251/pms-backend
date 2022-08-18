class Api::V1::DepartmentsController < ApplicationController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_department, only: [:show, :update, :destroy]

  # GET /departments
  def index
    query = "SELECT dp.id as value, dp.name as label FROM departments as dp"
    @salary_modes = execute_sql_query(query)
    render json: @salary_modes
  end

  # # GET /departments/1
  # def show
  #   render json: @department
  # end

  # # POST /departments
  # def create
  #   @department = Department.new(department_params)

  #   if @department.save
  #     render json: @department, status: :created, location: @department
  #   else
  #     render json: @department.errors, status: :unprocessable_entity
  #   end
  # end

  # # PATCH/PUT /departments/1
  # def update
  #   if @department.update(department_params)
  #     render json: @department
  #   else
  #     render json: @department.errors, status: :unprocessable_entity
  #   end
  # end

  # # DELETE /departments/1
  # def destroy
  #   @department.destroy
  # end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_department
  #     @department = Department.find(params[:id])
  #   end

  #   # Only allow a trusted parameter "white list" through.
  #   def department_params
  #     params.fetch(:department, {})
  #   end
end
