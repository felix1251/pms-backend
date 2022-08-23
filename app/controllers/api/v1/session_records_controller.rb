class Api::V1::SessionRecordsController < PmsDesktopController
  # before_action :set_session_record, only: [:show, :update, :destroy]

  # # GET /session_records
  # def index
  #   @session_records = SessionRecord.all

  #   render json: @session_records
  # end

  # # GET /session_records/1
  # def show
  #   render json: @session_record
  # end

  # # POST /session_records
  # def create
  #   @session_record = SessionRecord.new(session_record_params)

  #   if @session_record.save
  #     render json: @session_record, status: :created, location: @session_record
  #   else
  #     render json: @session_record.errors, status: :unprocessable_entity
  #   end
  # end

  # # PATCH/PUT /session_records/1
  # def update
  #   if @session_record.update(session_record_params)
  #     render json: @session_record
  #   else
  #     render json: @session_record.errors, status: :unprocessable_entity
  #   end
  # end

  # # DELETE /session_records/1
  # def destroy
  #   @session_record.destroy
  # end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_session_record
  #     @session_record = SessionRecord.find(params[:id])
  #   end

  #   # Only allow a trusted parameter "white list" through.
  #   def session_record_params
  #     params.require(:session_record).permit(:ip_address)
  #   end
end
