require "rails_helper"

RSpec.describe TypeOfLeavesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/type_of_leaves").to route_to("type_of_leaves#index")
    end

    it "routes to #show" do
      expect(:get => "/type_of_leaves/1").to route_to("type_of_leaves#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/type_of_leaves").to route_to("type_of_leaves#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/type_of_leaves/1").to route_to("type_of_leaves#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/type_of_leaves/1").to route_to("type_of_leaves#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/type_of_leaves/1").to route_to("type_of_leaves#destroy", :id => "1")
    end
  end
end
