require 'rails_helper'

RSpec.describe "Overtimes", type: :request do
  describe "GET /overtimes" do
    it "works! (now write some real specs)" do
      get overtimes_path
      expect(response).to have_http_status(200)
    end
  end
end
