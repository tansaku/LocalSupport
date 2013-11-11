require 'spec_helper'
describe UsersController do
  describe 'PUT update' do
    context 'when signed in as non-admin' do
      before(:each) do
        user = double("User")
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
        @nonadmin_user = double("User")
        User.stub(:find_by_id).with("4").and_return(@nonadmin_user)
        @nonadmin_user.stub(:pending_organization_id=).with('5')
        @nonadmin_user.stub(:save!)
      end
      it 'should update the pending organization id to nested org id' do
        User.should_receive(:find_by_id).with("4").and_return(@nonadmin_user)
        @nonadmin_user.should_receive(:pending_organization_id=).with('5')
        @nonadmin_user.should_receive(:save!)
        put :update, id: 4, organization_id: 5
      end
      it 'should redirect to the show page for nested org' do
        put :update, id: 4, organization_id: 5
        expect(response).to redirect_to(organization_path(5))
      end
      it 'should display that a user has requested admin status for nested org' do
        put :update, id: 4, organization_id: 5
        expect(flash[:notice]).to have_content("You have requested admin status for My Organization")
      end
    end
  end
end
