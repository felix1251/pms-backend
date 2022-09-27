require "rails_helper"

RSpec.describe OvertimesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/overtimes").to route_to("overtimes#index")
    end

    it "routes to #show" do
      expect(:get => "/overtimes/1").to route_to("overtimes#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/overtimes").to route_to("overtimes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/overtimes/1").to route_to("overtimes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/overtimes/1").to route_to("overtimes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/overtimes/1").to route_to("overtimes#destroy", :id => "1")
    end
  end
end
