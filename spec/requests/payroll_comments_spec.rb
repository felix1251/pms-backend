require 'rails_helper'

RSpec.describe "PayrollComments", type: :request do
  describe "GET /payroll_comments" do
    it "works! (now write some real specs)" do
      get payroll_comments_path
      expect(response).to have_http_status(200)
    end
  end
end
