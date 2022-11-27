class WelcomeController < PmsDesktopController
      def index
            render json:  {:message => "Welcome :)"}
      end
end