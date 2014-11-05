require 'spec_helper'
require 'debugger'

class DummyController

  attr_accessor :params
  attr_reader :organisations
  attr_reader :resend_invitation
  attr_reader :json
  attr_reader :category_options

  def initialize
    @params = {}
  end

  def controller_name
    'organisations'
  end
end

describe ControllerExtensions::Organisations::Defaults do
  let(:controller) { DummyController.new }
  let(:orgs) { [(double :organisation), (double :organisation)] }

  context ControllerExtensions::Organisations::Index do
    before do
      expect(controller).to receive(:gmap4rails_with_popup_partial).with(orgs, 'popup')
      expect(Category).to receive(:html_drop_down_options)
      controller.stub(example.metadata.slice(:admin?))
      controller.params = example.metadata.slice(:scopes)
      controller.params[:service] ||= 'index'
      controller.extend ControllerExtension.for controller
    end

    context 'only an admin can override scopes and everyone receives a sensible default' do
      it 'normal user with no override gets default scope \'order_by_most_recent\'', admin?: false do
        expect(Organisation).to receive(:order_by_most_recent).and_return orgs
        controller.set_params
        controller.set_instance_variables
        expect(controller.params[:scopes]).to eq ['order_by_most_recent']
      end

      it 'admin user with no override gets default scope \'order_by_most_recent\'', admin?: true do
        expect(Organisation).to receive(:order_by_most_recent).and_return orgs
        controller.set_params
        controller.set_instance_variables
        expect(controller.params[:scopes]).to eq ['order_by_most_recent']
      end

      it 'normal user with override gets default scope \'order_by_most_recent\'', admin?: false, scopes: ['hello'] do
        expect(Organisation).to receive(:order_by_most_recent).and_return orgs
        controller.set_params
        controller.set_instance_variables
        expect(controller.params[:scopes]).to eq ['order_by_most_recent']
      end

      it 'admin user with override gets new scope \'hello\'', admin?: true, scopes: ['hello'] do
        expect(Organisation).to receive(:hello).and_return orgs
        controller.set_params
        controller.set_instance_variables
        expect(controller.params[:scopes]).to eq ['hello']
      end
    end
  end

  context ControllerExtensions::Organisations::WithoutUsers do
    it 'non-admins will not benefit from extensions params overriding abilities' do
      controller.stub admin?: false
      controller.params[:service] = 'without_users'
      controller.extend ControllerExtension.for controller
      controller.set_params
      expect(controller.params[:template]).to eq 'organisations/index'
    end

    context 'admins' do
      before do
        controller.stub admin?: true
        controller.params[:service] = 'without_users'
        controller.extend ControllerExtension.for controller
        controller.set_params
      end

      context 'will have new params set' do
        {
            template: 'without_users_index',
            layout: 'invitation_table',
            scopes: ['not_null_email','null_users','without_matching_user_emails'],
        }.each do |k, v|
          it do
            if k == :template
              v = v.prepend(controller.controller_name + '/')
            end
            expect(controller.params[k]).to eq v
          end
        end
      end

      context 'instance variables set' do
        before do
          expect(controller).to receive(:gmap4rails_with_popup_partial).with(orgs, 'popup')
          expect(Category).to receive(:html_drop_down_options)
          expect(Organisation).to receive(:without_matching_user_emails).and_return orgs
        end
        it do
          controller.set_instance_variables
          expect(controller.resend_invitation).to eq false
        end

        it do
          controller.set_instance_variables
          expect(controller.organisations).to eq orgs
        end
      end
    end
  end

end
