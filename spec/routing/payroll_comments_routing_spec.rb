require "rails_helper"

RSpec.describe PayrollCommentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/payroll_comments").to route_to("payroll_comments#index")
    end

    it "routes to #show" do
      expect(:get => "/payroll_comments/1").to route_to("payroll_comments#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/payroll_comments").to route_to("payroll_comments#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/payroll_comments/1").to route_to("payroll_comments#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/payroll_comments/1").to route_to("payroll_comments#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/payroll_comments/1").to route_to("payroll_comments#destroy", :id => "1")
    end
  end
end
