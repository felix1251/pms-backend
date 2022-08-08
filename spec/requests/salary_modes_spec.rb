require 'rails_helper'

RSpec.describe "SalaryModes", type: :request do
  describe "GET /salary_modes" do
    it "works! (now write some real specs)" do
      get salary_modes_path
      expect(response).to have_http_status(200)
    end
  end
end
