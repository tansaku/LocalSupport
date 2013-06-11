require 'spec_helper'

describe Devise::RegistrationsController do
  before :suite do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
  end

  describe "POST create" do
    before :each do
      request.env["devise.mapping"] = Devise.mappings[:charity_worker]
      post :create, 'charity_worker' => {'email' => 'example@example.com', 'password' => 'pppppppp', 'password_confirmation' => 'pppppppp'}
    end
    it 'does not email upon registration' do
      expect(ActionMailer::Base.deliveries).to be_empty
    end
    it 'redirects to home page after registration form' do
      expect(response).to redirect_to root_url
    end
  end
end
