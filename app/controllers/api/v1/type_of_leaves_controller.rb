class Api::V1::TypeOfLeavesController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_type_of_leafe, only: [:show, :update, :destroy]

  # GET /type_of_leaves
  def index
    type_of_leaves = TypeOfLeave.select('id, id as value, name as label, with_pay').all
    render json: type_of_leaves
  end

  # # GET /type_of_leaves/1
  # def show
  #   render json: @type_of_leafe
  # end

  # # POST /type_of_leaves
  # def create
  #   @type_of_leafe = TypeOfLeave.new(type_of_leafe_params)

  #   if @type_of_leafe.save
  #     render json: @type_of_leafe, status: :created, location: @type_of_leafe
  #   else
  #     render json: @type_of_leafe.errors, status: :unprocessable_entity
  #   end
  # end

  # # PATCH/PUT /type_of_leaves/1
  # def update
  #   if @type_of_leafe.update(type_of_leafe_params)
  #     render json: @type_of_leafe
  #   else
  #     render json: @type_of_leafe.errors, status: :unprocessable_entity
  #   end
  # end

  # # DELETE /type_of_leaves/1
  # def destroy
  #   @type_of_leafe.destroy
  # end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_type_of_leafe
  #     @type_of_leafe = TypeOfLeave.find(params[:id])
  #   end

  #   # Only allow a trusted parameter "white list" through.
  #   def type_of_leafe_params
  #     params.require(:type_of_leafe).permit(:name)
  #   end
end
