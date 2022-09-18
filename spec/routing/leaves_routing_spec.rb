require "rails_helper"

RSpec.describe LeavesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/leaves").to route_to("leaves#index")
    end

    it "routes to #show" do
      expect(:get => "/leaves/1").to route_to("leaves#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/leaves").to route_to("leaves#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/leaves/1").to route_to("leaves#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/leaves/1").to route_to("leaves#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/leaves/1").to route_to("leaves#destroy", :id => "1")
    end
  end
end
