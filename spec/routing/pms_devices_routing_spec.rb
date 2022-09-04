require "rails_helper"

RSpec.describe PmsDevicesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/pms_devices").to route_to("pms_devices#index")
    end

    it "routes to #show" do
      expect(:get => "/pms_devices/1").to route_to("pms_devices#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/pms_devices").to route_to("pms_devices#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/pms_devices/1").to route_to("pms_devices#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/pms_devices/1").to route_to("pms_devices#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/pms_devices/1").to route_to("pms_devices#destroy", :id => "1")
    end
  end
end
