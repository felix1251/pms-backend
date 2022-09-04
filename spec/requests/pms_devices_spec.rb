require 'rails_helper'

RSpec.describe "PmsDevices", type: :request do
  describe "GET /pms_devices" do
    it "works! (now write some real specs)" do
      get pms_devices_path
      expect(response).to have_http_status(200)
    end
  end
end
