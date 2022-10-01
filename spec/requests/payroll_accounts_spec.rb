require 'rails_helper'

RSpec.describe "PayrollAccounts", type: :request do
  describe "GET /payroll_accounts" do
    it "works! (now write some real specs)" do
      get payroll_accounts_path
      expect(response).to have_http_status(200)
    end
  end
end
