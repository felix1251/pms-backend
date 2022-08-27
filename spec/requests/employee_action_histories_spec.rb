require 'rails_helper'

RSpec.describe "EmployeeActionHistories", type: :request do
  describe "GET /employee_action_histories" do
    it "works! (now write some real specs)" do
      get employee_action_histories_path
      expect(response).to have_http_status(200)
    end
  end
end
