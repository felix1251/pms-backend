require 'rails_helper'

RSpec.describe "OfficialBusinesses", type: :request do
  describe "GET /official_businesses" do
    it "works! (now write some real specs)" do
      get official_businesses_path
      expect(response).to have_http_status(200)
    end
  end
end
