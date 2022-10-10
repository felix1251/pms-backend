class Api::Admin::PagibigsController < AdministratorsController
  before_action :authorize_access_request!
  before_action :set_pagibig, only: [:show, :update, :destroy]

  # GET /pagibigs
  def index
    @pagibigs = Pagibig.all
    render json: @pagibigs
  end

  # GET /pagibigs/1
  def show
    render json: @pagibig
  end

  # POST /pagibigs
  def create
    @pagibig = Pagibig.new(pagibig_params)
    if @pagibig.save
      render json: @pagibig, status: :created, location: @pagibig
    else
      render json: @pagibig.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pagibigs/1
  def update
    if @pagibig.update(pagibig_params)
      render json: @pagibig
    else
      render json: @pagibig.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pagibigs/1
  def destroy
    @pagibig.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pagibig
      @pagibig = Pagibig.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def pagibig_params
      params.require(:pagibig).permit(:amount, :title)
    end
end
