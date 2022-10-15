require 'rails_helper'

RSpec.describe "EmployeeAllowances", type: :request do
  describe "GET /employee_allowances" do
    it "works! (now write some real specs)" do
      get employee_allowances_path
      expect(response).to have_http_status(200)
    end
  end
end
