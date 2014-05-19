class InvitationsController < ApplicationController
  before_filter :authorize

  # xhr only, tested in a request spec
  def create
    flag = params.fetch(:resend_invitation).to_s == 'true' ? true : false
    Devise.resend_invitation = flag
    answers = params.fetch(:values).map do |invite|
      user = User.invite!({email: invite.fetch(:email)}, current_user) do |user|
        user.organization_id = invite.fetch(:id)
      end
      answer = if user.errors.any?
                   user.errors.full_messages.map{|msg| "Error: #{msg}"}.join(' ')
                 else
                   'Invited!'
                 end
      {invite.fetch(:id) => answer}
    end
    render json: answers.reduce({}, :update).to_json
  end
end
