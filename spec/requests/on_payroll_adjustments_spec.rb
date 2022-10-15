require 'rails_helper'

RSpec.describe "OnPayrollAdjustments", type: :request do
  describe "GET /on_payroll_adjustments" do
    it "works! (now write some real specs)" do
      get on_payroll_adjustments_path
      expect(response).to have_http_status(200)
    end
  end
end
