class  Api::V1::DeviceSessionRecordsController < PmsDesktopController
  # before_action :set_device_session_record, only: [:show, :update, :destroy]

  # # GET /device_session_records
  # def index
  #   @device_session_records = DeviceSessionRecord.all

  #   render json: @device_session_records
  # end

  # # GET /device_session_records/1
  # def show
  #   render json: @device_session_record
  # end

  # # POST /device_session_records
  # def create
  #   @device_session_record = DeviceSessionRecord.new(device_session_record_params)

  #   if @device_session_record.save
  #     render json: @device_session_record, status: :created, location: @device_session_record
  #   else
  #     render json: @device_session_record.errors, status: :unprocessable_entity
  #   end
  # end

  # # PATCH/PUT /device_session_records/1
  # def update
  #   if @device_session_record.update(device_session_record_params)
  #     render json: @device_session_record
  #   else
  #     render json: @device_session_record.errors, status: :unprocessable_entity
  #   end
  # end

  # # DELETE /device_session_records/1
  # def destroy
  #   @device_session_record.destroy
  # end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_device_session_record
  #     @device_session_record = DeviceSessionRecord.find(params[:id])
  #   end

  #   # Only allow a trusted parameter "white list" through.
  #   def device_session_record_params
  #     params.require(:device_session_record).permit(:ip_address, :name)
  #   end
end
