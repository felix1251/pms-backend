class PayrollCommentsChannel < ApplicationCable::Channel
  
  def subscribed
    stream_from "payroll_#{params[:payroll_id]}"
    reject unless params[:company_id] == current_user.company_id
  end

  def unsubscribed
  end
end
