require 'rails_helper'

RSpec.describe "AssignedAreas", type: :request do
  describe "GET /assigned_areas" do
    it "works! (now write some real specs)" do
      get assigned_areas_path
      expect(response).to have_http_status(200)
    end
  end
end
