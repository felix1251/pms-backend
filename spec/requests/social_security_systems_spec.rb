require 'rails_helper'

RSpec.describe "SocialSecuritySystems", type: :request do
  describe "GET /social_security_systems" do
    it "works! (now write some real specs)" do
      get social_security_systems_path
      expect(response).to have_http_status(200)
    end
  end
end
