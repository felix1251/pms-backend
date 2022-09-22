require "rails_helper"

RSpec.describe CompanyAccountsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/company_accounts").to route_to("company_accounts#index")
    end

    it "routes to #show" do
      expect(:get => "/company_accounts/1").to route_to("company_accounts#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/company_accounts").to route_to("company_accounts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/company_accounts/1").to route_to("company_accounts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/company_accounts/1").to route_to("company_accounts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/company_accounts/1").to route_to("company_accounts#destroy", :id => "1")
    end
  end
end
