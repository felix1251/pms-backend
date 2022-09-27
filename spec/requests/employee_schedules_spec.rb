require 'rails_helper'

RSpec.describe "EmployeeSchedules", type: :request do
  describe "GET /employee_schedules" do
    it "works! (now write some real specs)" do
      get employee_schedules_path
      expect(response).to have_http_status(200)
    end
  end
end
