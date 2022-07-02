require "rails_helper"

RSpec.describe PageActionAccessesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/page_action_accesses").to route_to("page_action_accesses#index")
    end

    it "routes to #show" do
      expect(:get => "/page_action_accesses/1").to route_to("page_action_accesses#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/page_action_accesses").to route_to("page_action_accesses#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/page_action_accesses/1").to route_to("page_action_accesses#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/page_action_accesses/1").to route_to("page_action_accesses#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/page_action_accesses/1").to route_to("page_action_accesses#destroy", :id => "1")
    end
  end
end
