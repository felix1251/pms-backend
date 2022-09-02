require "rails_helper"

RSpec.describe EmployeeActionHistoriesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/employee_action_histories").to route_to("employee_action_histories#index")
    end

    it "routes to #show" do
      expect(:get => "/employee_action_histories/1").to route_to("employee_action_histories#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/employee_action_histories").to route_to("employee_action_histories#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/employee_action_histories/1").to route_to("employee_action_histories#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/employee_action_histories/1").to route_to("employee_action_histories#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/employee_action_histories/1").to route_to("employee_action_histories#destroy", :id => "1")
    end
  end
end
