require 'ruby-holidayapi'
class Api::V1::HolidaysController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_holiday, only: [:show, :update, :destroy]

  # GET /holidays
  def index
    sql = "SELECT *"
    sql += " FROM holidays"
    sql += " WHERE company_id = #{payload['company_id']}"
    sql += " AND DATE_FORMAT(date, '%Y-%m') = '#{params[:ym]}'" if params[:ym].present?
    holidays = execute_sql_query(sql)
    render json: holidays
  end

  # GET /holidays/1
  def show
    render json: @holiday
  end

  # def holidays_api
  #   key = '56a0044c-c73f-4262-b873-bebd29771fc1'
  #   hapi = HolidayAPI::V1.new(key)
  #   holidays = hapi.holidays({
  #     'country': 'PH',
  #     'year': '2022',
  #   })
  #   render json: holidays
  # end

  # POST /holidays
  def create
    @holiday = Holiday.new(holiday_params.merge!({company_id: payload['company_id']}))

    if @holiday.save
      render json: @holiday, status: :created
    else
      render json: @holiday.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /holidays/1
  def update
    if @holiday.update(holiday_params)
      render json: @holiday
    else
      render json: @holiday.errors, status: :unprocessable_entity
    end
  end

  # DELETE /holidays/1
  def destroy
    @holiday.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_holiday
      @holiday = Holiday.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def holiday_params
      params.require(:holiday).permit(:type_of_holiday, :date, :title)
    end
end
