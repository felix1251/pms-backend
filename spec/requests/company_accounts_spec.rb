require 'rails_helper'

RSpec.describe "CompanyAccounts", type: :request do
  describe "GET /company_accounts" do
    it "works! (now write some real specs)" do
      get company_accounts_path
      expect(response).to have_http_status(200)
    end
  end
end
