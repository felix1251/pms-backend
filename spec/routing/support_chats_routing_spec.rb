require "rails_helper"

RSpec.describe SupportChatsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/support_chats").to route_to("support_chats#index")
    end

    it "routes to #show" do
      expect(:get => "/support_chats/1").to route_to("support_chats#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/support_chats").to route_to("support_chats#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/support_chats/1").to route_to("support_chats#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/support_chats/1").to route_to("support_chats#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/support_chats/1").to route_to("support_chats#destroy", :id => "1")
    end
  end
end
