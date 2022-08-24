class WelcomeController < PmsDesktopController
      def index
            msg = "Welcome :)"
            render json:  {:message => msg}
      end
end