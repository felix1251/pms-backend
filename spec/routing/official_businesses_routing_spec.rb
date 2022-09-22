require "rails_helper"

RSpec.describe OfficialBusinessesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/official_businesses").to route_to("official_businesses#index")
    end

    it "routes to #show" do
      expect(:get => "/official_businesses/1").to route_to("official_businesses#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/official_businesses").to route_to("official_businesses#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/official_businesses/1").to route_to("official_businesses#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/official_businesses/1").to route_to("official_businesses#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/official_businesses/1").to route_to("official_businesses#destroy", :id => "1")
    end
  end
end
