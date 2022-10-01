require "rails_helper"

RSpec.describe PayrollAccountsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/payroll_accounts").to route_to("payroll_accounts#index")
    end

    it "routes to #show" do
      expect(:get => "/payroll_accounts/1").to route_to("payroll_accounts#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/payroll_accounts").to route_to("payroll_accounts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/payroll_accounts/1").to route_to("payroll_accounts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/payroll_accounts/1").to route_to("payroll_accounts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/payroll_accounts/1").to route_to("payroll_accounts#destroy", :id => "1")
    end
  end
end
