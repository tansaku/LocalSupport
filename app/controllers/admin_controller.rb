class AdminsController < ApplicationController
  layout 'full_width'
  before_filter :authorize
  include AdminsHelper

  def organizations_without_users
    @orphans = Organization.not_null_email.null_users
    @orphans += Organization.not_null_email.generated_users
  end

  # http://stackoverflow.com/questions/5315465/rails-3-link-to-generator-for-post-put-delete
  # since graceful degradation is impossible anyway, js-disabled users can suck it
  def organizations_without_users_create
    res = params[:organizations].reduce({}) do |hash, id|
      user = Organization.find_by_id(id).generate_potential_user
      msg = user.errors.any? ? 'Error: ' + user.errors.full_messages.first : retrieve_password_url(user.reset_password_token)
      hash[id] = msg
      hash
    end
    respond_to do |format|
      format.json { render :json => res.to_json }
    end
  end
end