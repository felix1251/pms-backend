require 'rails_helper'

RSpec.describe "OffsetOvertimes", type: :request do
  describe "GET /offset_overtimes" do
    it "works! (now write some real specs)" do
      get offset_overtimes_path
      expect(response).to have_http_status(200)
    end
  end
end
