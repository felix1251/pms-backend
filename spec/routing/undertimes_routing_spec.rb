require "rails_helper"

RSpec.describe UndertimesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/undertimes").to route_to("undertimes#index")
    end

    it "routes to #show" do
      expect(:get => "/undertimes/1").to route_to("undertimes#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/undertimes").to route_to("undertimes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/undertimes/1").to route_to("undertimes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/undertimes/1").to route_to("undertimes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/undertimes/1").to route_to("undertimes#destroy", :id => "1")
    end
  end
end
