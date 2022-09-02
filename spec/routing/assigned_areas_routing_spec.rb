require "rails_helper"

RSpec.describe AssignedAreasController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/assigned_areas").to route_to("assigned_areas#index")
    end

    it "routes to #show" do
      expect(:get => "/assigned_areas/1").to route_to("assigned_areas#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/assigned_areas").to route_to("assigned_areas#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/assigned_areas/1").to route_to("assigned_areas#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/assigned_areas/1").to route_to("assigned_areas#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/assigned_areas/1").to route_to("assigned_areas#destroy", :id => "1")
    end
  end
end
