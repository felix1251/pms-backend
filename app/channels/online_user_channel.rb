class OnlineUserChannel < ApplicationCable::Channel
  
  def subscribed
    stream_from "company_#{params[:company_id]}"
    if current_user.company_id == params[:company_id]
      current_user.update(online: true)
    else
      reject
    end
  end

  def unsubscribed
    current_user.update(online: false)
  end
end
