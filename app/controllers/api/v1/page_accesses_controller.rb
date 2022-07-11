class PageAccessesController < ApplicationController
  before_action :set_page_access, only: [:show, :update, :destroy]

  # GET /page_accesses
  def index
    @page_accesses = PageAccess.all

    render json: @page_accesses
  end

  # GET /page_accesses/1
  def show
    render json: @page_access
  end

  # POST /page_accesses
  def create
    @page_access = PageAccess.new(page_access_params)

    if @page_access.save
      render json: @page_access, status: :created, location: @page_access
    else
      render json: @page_access.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /page_accesses/1
  def update
    if @page_access.update(page_access_params)
      render json: @page_access
    else
      render json: @page_access.errors, status: :unprocessable_entity
    end
  end

  # DELETE /page_accesses/1
  def destroy
    @page_access.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page_access
      @page_access = PageAccess.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def page_access_params
      params.fetch(:page_access, {})
    end
end
