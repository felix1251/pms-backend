module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

      def find_verified_user
        if verified_user = User.find(user_id) rescue nil
          verified_user
        else
          reject_unauthorized_connection
        end
      end

      def user_id
        user = JWTSessions::Token.decode(token).first rescue nil
        return user["user_id"]
      end

      def token
        request.params["token"]
      end
  end
end
