require 'rails_helper'

RSpec.describe "EmploymentStatuses", type: :request do
  describe "GET /employment_statuses" do
    it "works! (now write some real specs)" do
      get employment_statuses_path
      expect(response).to have_http_status(200)
    end
  end
end
