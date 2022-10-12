require 'rails_helper'

RSpec.describe "Philhealths", type: :request do
  describe "GET /philhealths" do
    it "works! (now write some real specs)" do
      get philhealths_path
      expect(response).to have_http_status(200)
    end
  end
end
