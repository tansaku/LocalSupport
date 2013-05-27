require 'spec_helper'

describe OrganizationsController do
  before :suite do
    FactoryGirl.reload
  end

  def mock_organization(stubs={})
    (@mock_organization ||= mock_model(Organization).as_null_object).tap do |organization|
      organization.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET search" do
    it "searches all organizations as @organizations" do
      result = [mock_organization]
      json='my markers'
      result.should_receive(:to_gmaps4rails).and_return(json)
      Organization.should_receive(:search_by_keyword).with('test').and_return(result)

      get :search, :q => 'test'
      response.should render_template 'index'

      assigns(:organizations).should eq([mock_organization])
      assigns(:json).should eq(json)
    end
  end


  describe "GET index" do

    before(:each) do
      @orgs = []
      #create 25 organizations
      25.times do
        @orgs << FactoryGirl.build(:organization)
      end
      @page_size = 10
    end

    it 'assigns all organizations as @organizations' do
      mock_array = []
      mock_json = ""
      #this array expectation doesn't work and I don't know why
      #Array.should_receive(:to_gmaps4rails).and_return(mock_json)
      Organization.stub(:all) { mock_array }
      get :index

      assigns(:organizations).should eq(mock_array)
      assigns(:json).should eq("[]")
    end

    context 'organizations are paged, NO consequent calls (NO :last_index or last param is provided)' do

      it 'should return 1nd "page" if no params specified with default page size' do
        page_size = 10
        expected = @orgs[0...(page_size*1)]
        Organization.stub(:all) { @orgs }
        get :index
        expect(assigns(:organizations)).to eq(expected)
      end

      it 'should return 2nd "page" of @organizations array with default size of a page' do
        page_size = 10
        expected = @orgs[page_size...(page_size*2)]
        Organization.stub(:all) { @orgs }
        get :index, page: 2
        expect(assigns(:organizations)).to eq(expected)
      end

      it 'should return 2nd "page" of @organizations array with custom size of a page 5' do
        page_size = 5
        expected = @orgs[page_size...(page_size*2)]
        Organization.stub(:all) { @orgs }
        get :index, page: 2, page_size: page_size
        expect(assigns(:organizations)).to eq(expected)
      end

      #Page shouldn't be full, cuz range is [20..30], but array size is 25
      it 'should return 3rd "page" of @organizations array with default size of a page' do
        page_size = 10
        expected = @orgs[20...(page_size*3)]
        Organization.stub(:all) { @orgs }
        get :index, page: 3
        expect(assigns(:organizations)).to eq(expected)
      end

    end

  context 'organizations are paged, WITH consequent calls ( OR :last_index param is provided)' do

    it 'should display next page with provided param' do
      page_size = 5
      expected = @orgs[11...16]
      Organization.stub(:all) { @orgs }
      get :index, page: 'next', page_size: page_size, last_index: 11
      expect(assigns(:organizations)).to eq(expected)
    end

    it 'should display next page with consequent call' do
      page_size = 5
      expected = @orgs[5...10]
      Organization.stub(:all) { @orgs }
      get :index, page: 2, page_size: page_size
      expect(assigns(:organizations)).to eq(expected)

      page_size = 5
      expected = @orgs[10...15]
      Organization.stub(:all) { @orgs }
      get :index, page: 'next', page_size: page_size
      expect(assigns(:organizations)).to eq(expected)
    end

  end

end

describe "GET show" do
  it "assigns the requested organization as @organization" do
    Organization.stub(:find).with("37") { mock_organization }
    get :show, :id => "37"
    assigns(:organization).should be(mock_organization)
  end
end

describe "GET new" do
  context "while signed in" do
    before(:each) do
      @admin = FactoryGirl.create(:charity_worker)
      sign_in :charity_worker, @admin
    end
    it "assigns a new organization as @organization" do
      Organization.stub(:new) { mock_organization }
      get :new
      assigns(:organization).should be(mock_organization)
    end
  end
  context "while not signed in" do
    it "redirects to sign-in" do
      get :new
      expect(response).to redirect_to new_charity_worker_session_path
    end
  end
end

describe "GET edit" do
  context "while signed in" do
    before(:each) do
      @admin = FactoryGirl.create(:charity_worker)
      sign_in :charity_worker, @admin
    end
    it "assigns the requested organization as @organization" do
      Organization.stub(:find).with("37") { mock_organization }
      get :edit, :id => "37"
      assigns(:organization).should be(mock_organization)
    end
  end
  #TODO: way to dry out these redirect specs?
  context "while not signed in" do
    it "redirects to sign-in" do
      get :edit, :id => 37
      expect(response).to redirect_to new_charity_worker_session_path
    end
  end
end

describe "POST create" do
  context "while signed in" do
    before(:each) do
      @admin = FactoryGirl.create(:charity_worker)
      sign_in :charity_worker, @admin
    end
    describe "with valid params" do
      it "assigns a newly created organization as @organization" do
        Organization.stub(:new).with({'these' => 'params'}) { mock_organization(:save => true) }
        post :create, :organization => {'these' => 'params'}
        assigns(:organization).should be(mock_organization)
      end

      it "redirects to the created organization" do
        Organization.stub(:new) { mock_organization(:save => true) }
        post :create, :organization => {}
        response.should redirect_to(organization_url(mock_organization))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved organization as @organization" do
        Organization.stub(:new).with({'these' => 'params'}) { mock_organization(:save => false) }
        post :create, :organization => {'these' => 'params'}
        assigns(:organization).should be(mock_organization)
      end

      it "re-renders the 'new' template" do
        Organization.stub(:new) { mock_organization(:save => false) }
        post :create, :organization => {}
        response.should render_template("new")
      end
    end
  end
  context "while not signed in" do
    it "redirects to sign-in" do
      Organization.stub(:new).with({'these' => 'params'}) { mock_organization(:save => true) }
      post :create, :organization => {'these' => 'params'}
      expect(response).to redirect_to new_charity_worker_session_path
    end
  end
end

describe "PUT update" do
  context "while signed in" do
    before(:each) do
      @admin = FactoryGirl.create(:charity_worker)
      sign_in :charity_worker, @admin
    end
    describe "with valid params" do
      it "updates the requested organization" do
        Organization.should_receive(:find).with("37") { mock_organization }
        mock_organization.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :organization => {'these' => 'params'}
      end

      it "updates donation_info url" do
        Organization.should_receive(:find).with("37") { mock_organization }
        mock_organization.should_receive(:update_attributes).with({'donation_info' => 'http://www.friendly.com/donate'})
        put :update, :id => "37", :organization => {'donation_info' => 'http://www.friendly.com/donate'}
      end

      it "assigns the requested organization as @organization" do
        Organization.stub(:find) { mock_organization(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:organization).should be(mock_organization)
      end

      it "redirects to the organization" do
        Organization.stub(:find) { mock_organization(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(organization_url(mock_organization))
      end
    end

    describe "with invalid params" do
      it "assigns the organization as @organization" do
        Organization.stub(:find) { mock_organization(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:organization).should be(mock_organization)
      end

      it "re-renders the 'edit' template" do
        Organization.stub(:find) { mock_organization(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end
  context "while not signed in" do
    it "redirects to sign-in" do
      put :update, :id => "1", :organization => {'these' => 'params'}
      expect(response).to redirect_to new_charity_worker_session_path
    end
  end
end

describe "DELETE destroy" do
  context "while signed in" do
    before(:each) do
      @admin = FactoryGirl.create(:charity_worker)
      sign_in :charity_worker, @admin
    end
    it "destroys the requested organization" do
      Organization.should_receive(:find).with("37") { mock_organization }
      mock_organization.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the organizations list" do
      Organization.stub(:find) { mock_organization }
      delete :destroy, :id => "1"
      response.should redirect_to(organizations_url)
    end
  end
  context "while not signed in" do
    it "redirects to sign-in" do
      delete :destroy, :id => "37"
      expect(response).to redirect_to new_charity_worker_session_path
    end
  end
end

end
