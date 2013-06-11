require 'spec_helper'

describe Devise::SessionsController do
  before :suite do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
  end

  describe "POST create" do
    before :each do
      request.env["devise.mapping"] = Devise.mappings[:charity_worker]
    end

    it 'redirects to home page after admin logs-in' do
      FactoryGirl.build(:charity_worker, {:email => 'example@example.com', :password => 'pppppppp', :admin => true}).save!
      post :create, 'charity_worker' => {'email' => 'example@example.com', 'password' => 'pppppppp'}
      expect(response).to redirect_to root_url
    end
    it 'redirects to home page after non-admin associated with nothing logs-in' do
      FactoryGirl.build(:charity_worker, {:email => 'example@example.com', :password => 'pppppppp'}).save!
      post :create, 'charity_worker' => {'email' => 'example@example.com', 'password' => 'pppppppp'}
      expect(response).to redirect_to root_url
    end
    it 'redirects to charity page after non-admin associated with org' do
       org = FactoryGirl.build(:organization)
       Gmaps4rails.should_receive(:geocode)
       org.save!
       FactoryGirl.build(:charity_worker, {:email => 'example@example.com', :password => 'pppppppp', :organization => org}).save!
      post :create, 'charity_worker' => {'email' => 'example@example.com', 'password' => 'pppppppp'}
      expect(response).to redirect_to organization_path(org.id)
    end
  end
end
