class Api::V1::MeController < PmsDesktopController
      before_action :authorize_access_request!
      before_action :check_backend_session

      def me
            curr_user = current_user
            render json: { 
                  user: curr_user,
                  settings: company_settings,
                  access: curr_user.page_accesses,
                  goTo: route(curr_user),
            }
      end

      def route (current_user)
            route = PageAccess.order('id ASC').find_by(access_code: current_user.page_accesses)
            return "/" + route.page.downcase.parameterize(separator: '-')   
      end
end