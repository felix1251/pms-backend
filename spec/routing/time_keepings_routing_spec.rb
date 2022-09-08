require "rails_helper"

RSpec.describe TimeKeepingsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/time_keepings").to route_to("time_keepings#index")
    end

    it "routes to #show" do
      expect(:get => "/time_keepings/1").to route_to("time_keepings#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/time_keepings").to route_to("time_keepings#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/time_keepings/1").to route_to("time_keepings#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/time_keepings/1").to route_to("time_keepings#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/time_keepings/1").to route_to("time_keepings#destroy", :id => "1")
    end
  end
end
