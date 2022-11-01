class Api::V2::PasswordChangeController < PmsErsController
      before_action :authorize_access_request!
      before_action :current_employee, only: [:create]

      def create
            if @employee.authenticate(params[:password])
                  if @employee.update(password: params[:new_password], password_confirmation: params[:confirm_password])
                        render json: {message: "Password changed successfully"} , status: :created
                  else
                        render json: @employee.errors, status: :unprocessable_entity
                  end
            else
                  render json: {password: ["Current password is incorrect"]}, status: :unprocessable_entity
            end
      end

      private

      def current_employee
            @employee = Employee.find(payload['employee_id'])
      end
end