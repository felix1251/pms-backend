module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include JWTSessions::RailsAuthorization
    identified_by :current_user

    def connect
      self.current_user
    end

    private
      # def find_verified_user
      #   puts "-----------#{request.params["sample"]}------------"
      #   user = JWTSessions::Token.decode(request.params['token']).first
      #   if verified_user = User.find(user["user_id"])
      #     verified_user
      #   else
      #     reject_unauthorized_connection
      #   end
      # end
  end
end
