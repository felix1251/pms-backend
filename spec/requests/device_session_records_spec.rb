require 'rails_helper'

RSpec.describe "DeviceSessionRecords", type: :request do
  describe "GET /device_session_records" do
    it "works! (now write some real specs)" do
      get device_session_records_path
      expect(response).to have_http_status(200)
    end
  end
end
