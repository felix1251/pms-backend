require "rails_helper"

RSpec.describe SssContributionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/sss_contributions").to route_to("sss_contributions#index")
    end

    it "routes to #show" do
      expect(:get => "/sss_contributions/1").to route_to("sss_contributions#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/sss_contributions").to route_to("sss_contributions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/sss_contributions/1").to route_to("sss_contributions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/sss_contributions/1").to route_to("sss_contributions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/sss_contributions/1").to route_to("sss_contributions#destroy", :id => "1")
    end
  end
end
