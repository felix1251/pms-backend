require "rails_helper"

RSpec.describe OffsetOvertimesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/offset_overtimes").to route_to("offset_overtimes#index")
    end

    it "routes to #show" do
      expect(:get => "/offset_overtimes/1").to route_to("offset_overtimes#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/offset_overtimes").to route_to("offset_overtimes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/offset_overtimes/1").to route_to("offset_overtimes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/offset_overtimes/1").to route_to("offset_overtimes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/offset_overtimes/1").to route_to("offset_overtimes#destroy", :id => "1")
    end
  end
end
