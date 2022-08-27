class Api::V1::PageActionAccessesController < PmsDesktopController
  # before_action :set_page_action_access, only: [:show, :update, :destroy]

  # # GET /page_action_accesses
  # def index
  #   @page_action_accesses = PageActionAccess.all

  #   render json: @page_action_accesses
  # end

  # # GET /page_action_accesses/1
  # def show
  #   render json: @page_action_access
  # end

  # # POST /page_action_accesses
  # def create
  #   @page_action_access = PageActionAccess.new(page_action_access_params)

  #   if @page_action_access.save
  #     render json: @page_action_access, status: :created, location: @page_action_access
  #   else
  #     render json: @page_action_access.errors, status: :unprocessable_entity
  #   end
  # end

  # # PATCH/PUT /page_action_accesses/1
  # def update
  #   if @page_action_access.update(page_action_access_params)
  #     render json: @page_action_access
  #   else
  #     render json: @page_action_access.errors, status: :unprocessable_entity
  #   end
  # end

  # # DELETE /page_action_accesses/1
  # def destroy
  #   @page_action_access.destroy
  # end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_page_action_access
  #     @page_action_access = PageActionAccess.find(params[:id])
  #   end

  #   # Only allow a trusted parameter "white list" through.
  #   def page_action_access_params
  #     params.fetch(:page_action_access, {})
  #   end
end
