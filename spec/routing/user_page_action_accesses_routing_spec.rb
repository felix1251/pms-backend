require "rails_helper"

RSpec.describe UserPageActionAccessesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/user_page_action_accesses").to route_to("user_page_action_accesses#index")
    end

    it "routes to #show" do
      expect(:get => "/user_page_action_accesses/1").to route_to("user_page_action_accesses#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/user_page_action_accesses").to route_to("user_page_action_accesses#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/user_page_action_accesses/1").to route_to("user_page_action_accesses#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/user_page_action_accesses/1").to route_to("user_page_action_accesses#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/user_page_action_accesses/1").to route_to("user_page_action_accesses#destroy", :id => "1")
    end
  end
end
