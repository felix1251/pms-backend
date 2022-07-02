require "rails_helper"

RSpec.describe UserPageAccessesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/user_page_accesses").to route_to("user_page_accesses#index")
    end

    it "routes to #show" do
      expect(:get => "/user_page_accesses/1").to route_to("user_page_accesses#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/user_page_accesses").to route_to("user_page_accesses#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/user_page_accesses/1").to route_to("user_page_accesses#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/user_page_accesses/1").to route_to("user_page_accesses#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/user_page_accesses/1").to route_to("user_page_accesses#destroy", :id => "1")
    end
  end
end
