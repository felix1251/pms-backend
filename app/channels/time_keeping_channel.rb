class TimeKeepingChannel < ApplicationCable::Channel
      def subscribed
            stream_from "time_keeping_#{params[:company_id]}"
            reject unless current_user.company_id == params[:company_id]
      end
      
      def unsubscribed
            puts "#{current_user.id} unsubscribed"
      end
end