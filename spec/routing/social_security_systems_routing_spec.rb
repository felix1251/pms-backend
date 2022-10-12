require "rails_helper"

RSpec.describe SocialSecuritySystemsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/social_security_systems").to route_to("social_security_systems#index")
    end

    it "routes to #show" do
      expect(:get => "/social_security_systems/1").to route_to("social_security_systems#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/social_security_systems").to route_to("social_security_systems#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/social_security_systems/1").to route_to("social_security_systems#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/social_security_systems/1").to route_to("social_security_systems#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/social_security_systems/1").to route_to("social_security_systems#destroy", :id => "1")
    end
  end
end
