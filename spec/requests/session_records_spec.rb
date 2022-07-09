require 'rails_helper'

RSpec.describe "SessionRecords", type: :request do
  describe "GET /session_records" do
    it "works! (now write some real specs)" do
      get session_records_path
      expect(response).to have_http_status(200)
    end
  end
end
