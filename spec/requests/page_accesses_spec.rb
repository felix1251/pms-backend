require 'rails_helper'

RSpec.describe "PageAccesses", type: :request do
  describe "GET /page_accesses" do
    it "works! (now write some real specs)" do
      get page_accesses_path
      expect(response).to have_http_status(200)
    end
  end
end
