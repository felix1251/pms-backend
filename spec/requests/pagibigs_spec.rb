require 'rails_helper'

RSpec.describe "Pagibigs", type: :request do
  describe "GET /pagibigs" do
    it "works! (now write some real specs)" do
      get pagibigs_path
      expect(response).to have_http_status(200)
    end
  end
end
