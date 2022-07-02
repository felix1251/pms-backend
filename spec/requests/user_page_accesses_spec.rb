require 'rails_helper'

RSpec.describe "UserPageAccesses", type: :request do
  describe "GET /user_page_accesses" do
    it "works! (now write some real specs)" do
      get user_page_accesses_path
      expect(response).to have_http_status(200)
    end
  end
end
