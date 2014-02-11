require 'spec_helper'

describe OrphansController do
  let(:org) { double('Organization') }
  let(:user) { double('User') }
  let(:session) { double(:admin? => true) }
  before(:each) { controller.stub(:current_user).and_return(session) }

  it 'is for admins only' do
    session.stub(:admin?).and_return(false)
    get :index
    response.should redirect_to '/'
    post :create
    response.should redirect_to '/'
  end

  describe '#index' do
    it 'assigns an instance variable' do
      Organization.stub_chain(:not_null_email, :null_users).and_return([org])
      Organization.stub_chain(:not_null_email, :generated_users).and_return([org])
      get :index
      assigns(:orphans).should eq([org, org])
    end
  end

  describe '#create' do
    let(:error) { double('ActiveModel::Errors') }
    before(:each) do
      request.accept = 'application/json'
      Organization.stub :find_by_id => org
      org.stub :generate_potential_user => user
    end

    it 'parses errors if there are any' do
      user.stub :errors => error
      error.stub :any? => true
      error.stub :full_messages
      error.stub_chain(:full_messages, :first).and_return('Ready to roll out!')
      post :create, { organizations: %w(1 3) }
      res = ActiveSupport::JSON.decode(response.body)
      res.should eq({'1' => 'Ready to roll out!', '3' => 'Ready to roll out!'})
    end

    it 'elicits the reset password token otherwise' do
      user.stub :errors => error
      error.stub :any? => false
      user.stub :reset_password_token => 'I-dentify target!'
      post :create, { organizations: %w(1 3) }
      res = ActiveSupport::JSON.decode(response.body)
      res.should eq({'1' => 'I-dentify target!', '3' => 'I-dentify target!'})
    end
  end
end