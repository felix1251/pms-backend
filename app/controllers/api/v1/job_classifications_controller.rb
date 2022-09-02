class Api::V1::JobClassificationsController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_job_classification, only: [:show, :update, :destroy]

  # GET /job_classifications
  def index
    sql_start = ""
    sql_start += "SELECT"
    sql_fields = " jc.id value, jc.name AS label, jc.code"
    sql_from = " FROM job_classifications AS jc"
    sql_conditions = " WHERE jc.status = 'A' and jc.company_id = #{payload['company_id']}"
    sql_sort = " ORDER BY jc.name ASC"

    if params[:page].present? && params[:per_page].present?
      max = 20
      current_page = params[:page].to_i 
      per_page = params[:per_page].to_i
      current_page = current_page || 1
      per_page = per_page || max
      unless per_page <= max
        per_page = max
      end
      records_fetch_point = (current_page - 1) * per_page

      sql_paginate = " LIMIT #{per_page} OFFSET #{records_fetch_point};"
      sql_count = " COUNT(*) as total_count"

      job_classifications = execute_sql_query(sql_start + sql_fields + sql_from + sql_conditions + sql_sort)
      counts = execute_sql_query(sql_start + sql_count + sql_from + sql_conditions)

      render json: {results: job_classifications, total_count: counts.first["total_count"] }
    else
      job_classifications = execute_sql_query(sql_start + sql_fields + sql_from + sql_conditions + sql_sort)
      render json: job_classifications
    end
  end

  # GET /job_classifications/1
  def show
    render json: @job_classification
  end

  # POST /job_classifications
  def create
    @job_classification = JobClassification.new(job_classification_params.merge!({company_id: payload["company_id"] ,created_by_id: payload['user_id']}))
    if @job_classification.save
      render json: @job_classification, status: :created
    else
      render json: @job_classification.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /job_classifications/1
  def update
    if @job_classification.update(job_classification_params)
      render json: @job_classification
    else
      render json: @job_classification.errors, status: :unprocessable_entity
    end
  end

  # DELETE /job_classifications/1
  def destroy
    @job_classification.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_classification
      @job_classification = JobClassification.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def job_classification_params
      params.require(:job_classification).permit(:name, :code)
    end
end
