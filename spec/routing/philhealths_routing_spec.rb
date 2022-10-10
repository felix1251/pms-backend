require "rails_helper"

RSpec.describe PhilhealthsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/philhealths").to route_to("philhealths#index")
    end

    it "routes to #show" do
      expect(:get => "/philhealths/1").to route_to("philhealths#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/philhealths").to route_to("philhealths#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/philhealths/1").to route_to("philhealths#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/philhealths/1").to route_to("philhealths#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/philhealths/1").to route_to("philhealths#destroy", :id => "1")
    end
  end
end
