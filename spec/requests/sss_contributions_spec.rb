require 'rails_helper'

RSpec.describe "SssContributions", type: :request do
  describe "GET /sss_contributions" do
    it "works! (now write some real specs)" do
      get sss_contributions_path
      expect(response).to have_http_status(200)
    end
  end
end
