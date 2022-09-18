require 'rails_helper'

RSpec.describe "Leaves", type: :request do
  describe "GET /leaves" do
    it "works! (now write some real specs)" do
      get leaves_path
      expect(response).to have_http_status(200)
    end
  end
end
