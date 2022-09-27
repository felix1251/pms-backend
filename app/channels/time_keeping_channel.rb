class TimeKeepingChannel < ApplicationCable::Channel
      def subscribed
            stream_from "time_keeping_#{current_user.company_id}"
            reject unless params[:company_id] == current_user.company_id
      end

      def unsubscribed
      end
end