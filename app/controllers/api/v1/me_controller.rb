class Api::V1::MeController < ApplicationController
      before_action :authorize_access_request!
      before_action :check_backend_session
      def me
            render json: { 
                  user: current_user, 
                  access: user_page_action_access(current_user),
                  goTo: '/'+user_page_action_route(current_user)
            }
      end
end