class InvitationsController < ApplicationController
  before_filter :authorize

  # xhr only, tested in a request spec
  def create
    tell_devise_if_okay_to_resend_invitations
    invites = get_invitations
    invites.each do |organization_id, email|
       user = invite_user(email, organization_id)
       invites[organization_id] = check_result_of_inviting user
    end
    render json: invites.to_json
  end

  def tell_devise_if_okay_to_resend_invitations
    flag = params.fetch(:resend_invitation).to_s == 'true'
    Devise.resend_invitation = flag
  end

  def invite_user email, organization_id
    User.invite!({email: email}) do |user|
      user.organization_id = organization_id
    end
  end

  def check_result_of_inviting user
    if user.errors.any?
      user.errors.full_messages.map{|msg| "Error: #{msg}"}.join(' ')
    else
      'Invited!'
    end
  end

  def get_invitations
    params.fetch(:values).reduce({}, :update)
  end
end
