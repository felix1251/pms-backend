require 'rails_helper'

RSpec.describe "Offsets", type: :request do
  describe "GET /offsets" do
    it "works! (now write some real specs)" do
      get offsets_path
      expect(response).to have_http_status(200)
    end
  end
end
