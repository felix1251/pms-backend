class OnlineUserChannel < ApplicationCable::Channel
  after_subscribe :online
  after_unsubscribe :offline

  def subscribed
    stream_from "company_#{current_user.company_id}"
    reject unless current_user.company_id == params[:company_id]
  end

  def unsubscribed
  end

  private

  def online
    current_user.update(online: true) if !current_user.online
    ActionCable.server.broadcast "company_#{current_user.company_id}", {online: total_online}
  end

  def offline
    current_user.update(online: false) if current_user.online
    ActionCable.server.broadcast "company_#{current_user.company_id}", {online: total_online}
  end

  def total_online
    User.where(company_id: current_user.company_id, status: "A", online: true).count
  end
end
