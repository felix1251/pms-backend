class Api::V1::PayrollCommentsController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_payroll_comment, only: [:show, :update, :destroy]
  # GET /payroll_comments

  def index
    sql = "SELECT"
    sql += " id, IF(user_id = #{payload['user_id']}, 'me', id) as author, comment_type AS type, time_sent, 1 AS sent_status,"
    sql += " JSON_OBJECT('text', comment, 'meta', created_at) AS data"
    sql += " FROM payroll_comments"
    sql += " WHERE payroll_id = #{params[:payroll_id]}"
    sql += " AND id < #{params[:min_id]}" if params[:min_id].present?
    sql += " ORDER BY id desc"
    sql += " LIMIT 11"
    payroll_comments = execute_sql_query(sql).each do |c| c["data"] = JSON.parse(c["data"]) end
    render json: payroll_comments
  end

  # GET /payroll_comments/1
  def show
    render json: @payroll_comment
  end

  # POST /payroll_comments
  def create
    @payroll_comment = PayrollComment.new(payroll_comment_params.merge!({user_id: payload['user_id']}))
    if @payroll_comment.save
      json_comment = {  
                        id: @payroll_comment.id,
                        type: @payroll_comment.comment_type, 
                        author: @payroll_comment.user_id,
                        sent_status: 1,
                        time_sent: @payroll_comment.time_sent,
                        data: { text: @payroll_comment.comment, meta: @payroll_comment.created_at}
                      }
      ActionCable.server.broadcast "payroll_#{@payroll_comment.payroll_id}", json_comment
      render json: @payroll_comment, status: :created
    else
      render json: @payroll_comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /payroll_comments/1
  def update
    if @payroll_comment.update(payroll_comment_params)
      render json: @payroll_comment
    else
      render json: @payroll_comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /payroll_comments/1
  def destroy
    @payroll_comment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payroll_comment
      @payroll_comment = PayrollComment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def payroll_comment_params
      params.require(:payroll_comment).permit(:payroll_id, :comment, :time_sent)
    end
end
