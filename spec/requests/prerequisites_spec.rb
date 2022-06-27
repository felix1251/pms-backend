require 'rails_helper'

RSpec.describe "Prerequisites", type: :request do
  describe "GET /prerequisites" do
    it "works! (now write some real specs)" do
      get prerequisites_path
      expect(response).to have_http_status(200)
    end
  end
end
