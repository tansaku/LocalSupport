require 'spec_helper'

describe "Invitations" do
  describe "POST /invitations", :helpers => :requests do
    let(:non_admin) { FactoryGirl.create(:user) }
    let(:admin) { FactoryGirl.create(:user, email: 'admin@example.com', admin: true) }
    let(:params) { {values: [{id: '3', email: 'what@ever.com'}], resend_invitation: false} }

    describe 'security' do
      it 'un-signed-in users not allowed' do
        xhr :post, invitations_path, params
        expect(response.code).to eq('302')
      end
      it 'non-admins not allowed' do
        login(non_admin)
        xhr :post, invitations_path, params
        expect(response.code).to eq('302')
      end
      it 'admins allowed' do
        login(admin)
        xhr :post, invitations_path, params
        expect(response.code).to eq('200')
      end
    end

    describe 'emails' do
      let(:email) { ActionMailer::Base.deliveries.last }
      before(:each) do
        ActionMailer::Base.deliveries.clear
        login(admin)
        xhr :post, invitations_path, params
      end

      it 'attributes' do
        email.from.should eq ['support@harrowcn.org.uk']
        email.reply_to.should eq ['support@harrowcn.org.uk']
        email.to.should eq ['what@ever.com']
        email.cc.should eq ['technical@harrowcn.org.uk']
        email.subject.should eq 'Invitation to Harrow Community Network'
      end
    end

    describe 'batch invites' do
      let(:org) { FactoryGirl.create :organization, email: 'yes@hello.com' }
      let(:params) do
        {values: [
          {id: org.id, email: org.email },
          {id: org.id+1, email: org.email }
        ],
        resend_invitation: false}
      end

      before do
        Gmaps4rails.stub :geocode
        login(admin)
      end

      it 'example response for invites with duplicates' do
        xhr :post, invitations_path, params
        expect(JSON.parse(response.body)).to eq(
          {org.id.to_s => 'Invited!',
           (org.id+1).to_s => 'Error: Email has already been taken'}
        )
      end
    end
  end
end
