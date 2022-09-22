require 'rails_helper'

RSpec.describe "CompensationHistories", type: :request do
  describe "GET /compensation_histories" do
    it "works! (now write some real specs)" do
      get compensation_histories_path
      expect(response).to have_http_status(200)
    end
  end
end
