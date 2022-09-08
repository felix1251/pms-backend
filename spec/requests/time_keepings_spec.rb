require 'rails_helper'

RSpec.describe "TimeKeepings", type: :request do
  describe "GET /time_keepings" do
    it "works! (now write some real specs)" do
      get time_keepings_path
      expect(response).to have_http_status(200)
    end
  end
end
