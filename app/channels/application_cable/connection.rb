module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private
      def find_verified_user
        user = JWTSessions::Token.decode(request.params["token"]).first rescue nil
        if verified_user = User.find(user["user_id"]) rescue nil
          verified_user
        else
          reject_unauthorized_connection
        end
      end
  end
end
