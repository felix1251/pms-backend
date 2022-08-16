class Api::V1::JobClassificationsController < ApplicationController
  before_action :set_job_classification, only: [:show, :update, :destroy]

  # GET /job_classifications
  def index
    @job_classifications = JobClassification.all

    render json: @job_classifications
  end

  # GET /job_classifications/1
  def show
    render json: @job_classification
  end

  # POST /job_classifications
  def create
    @job_classification = JobClassification.new(job_classification_params)

    if @job_classification.save
      render json: @job_classification, status: :created, location: @job_classification
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
      params.require(:job_classification).permit(:company_id_id, :description, :created_by)
    end
end
