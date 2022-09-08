class TimeKeepingChannel < ApplicationCable::Channel
      def subscribed
            stream_from "time_keeping_#{params[:company_id]}"
      end
end