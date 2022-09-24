require "rails_helper"

RSpec.describe OffsetsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/offsets").to route_to("offsets#index")
    end

    it "routes to #show" do
      expect(:get => "/offsets/1").to route_to("offsets#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/offsets").to route_to("offsets#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/offsets/1").to route_to("offsets#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/offsets/1").to route_to("offsets#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/offsets/1").to route_to("offsets#destroy", :id => "1")
    end
  end
end
