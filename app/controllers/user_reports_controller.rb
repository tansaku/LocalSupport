class UserReportsController < ApplicationController
  layout 'full_width'
  before_filter :authorize, :except => [:update]

  def update
    user = User.find_by_id(params[:id])
    if params[:organization_id]
      user.pending_organization_id = params[:organization_id]
      user.save!
      org = Organization.find(params[:organization_id])
      flash[:notice] = "You have requested admin status for #{org.name}"
      redirect_to(organization_path(params[:organization_id]))
    else
      redirect_to :status => 404 and return unless current_user.admin?
      user.promote_to_org_admin
      flash[:notice] = "You have approved #{user.email}."
      redirect_to '/user_reports/pending_admins_index'
    end
  end

  def pending_admins_index
    @users = User.all
  end
end
