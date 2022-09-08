class Api::V1::TimeKeepingsController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_time_keeping, only: [:show, :update, :destroy]

  # GET /time_keepings
  def index
    @time_keepings = TimeKeeping.all
    render json: @time_keepings
  end

  # GET /time_keepings/1
  def show
    render json: @time_keeping
  end

  # POST /time_keepings
  def create
    @time_keeping = TimeKeeping.new(time_keeping_params)
    if @time_keeping.save
      render json: @time_keeping, status: :created
    else
      render json: @time_keeping.errors, status: :unprocessable_entity
    end
  end

  def bulk_create
    record = request.params[:time_list] || []
    if record && record.length > 0
      company = Company.find(payload["company_id"])
      if company.update(pending_time_keeping: company.pending_time_keeping + record.length)
        ActionCable.server.broadcast "time_keeping_#{payload["company_id"]}", { pending: company.pending_time_keeping }
        TimeKeepingWorker.perform_async(record, payload["company_id"])
        render json: { message: "data processing" }, status: :created
      else
        render json: {error: "failed to update pending or company not exist"}, status: :unprocessable_entity
      end
    else
      render json: {error: "biometric data not valid or empty"}, status: :unprocessable_entity
    end
  end

  def time_keeping_counts
    sql = "SELECT"
    sql += " com.pending_time_keeping AS pending,"
    sql += " (SELECT COUNT(*) FROM time_keepings AS tk WHERE tk.company_id = com.id) AS succeeded,"
    sql += " (SELECT COUNT(*) FROM failed_time_keepings AS ftk WHERE ftk.company_id = com.id) AS rejected"
    sql += " FROM companies AS com"
    sql += " WHERE id = #{payload["company_id"]} LIMIT 1"

    counts = execute_sql_query(sql).first
    counts = counts.merge!({proccesed: counts["succeeded"] + counts["rejected"]})
    render json: counts
  end

  # PATCH/PUT /time_keepings/1
  def update
    if @time_keeping.update(time_keeping_params)
      render json: @time_keeping
    else
      render json: @time_keeping.errors, status: :unprocessable_entity
    end
  end

  # DELETE /time_keepings/1
  def destroy
    @time_keeping.destroy
  end

  def token_claims
    {
      aud: allowed_aud,
      verify_aud: true
    }
  end

  private
  
    def allowed_aud
      case action_name 
      when 'create', 'bulk_create'
        ['TA']
      when 'update'
        ['TE']
      when 'destroy'
        ['TD']
      else
        ['TV']
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_time_keeping
      @time_keeping = TimeKeeping.find(params[:id])
    end

    def bulk_allow_params
      params.permit(time_list: [])
    end

    # Only allow a trusted parameter "white list" through.
    def time_keeping_params
      params.require(:time_keeping).permit(:biomectric_no, :date, :status, :verified, :work_code, :record_type)
    end
end
