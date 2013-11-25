class UsersController < ApplicationController
  def update
    user = User.find_by_id(params[:id])
<<<<<<< Updated upstream
    user.pending_organization_id = params[:organization_id]
    user.save!
    flash[:notice] = "You have requested admin status for My Organization"
    redirect_to(organization_path(params[:organization_id]))
=======
    unless current_user.admin?
      params[:pending_organization_id] = params[:organization_id]
      params.delete :organization_id
      notice = "You have requested admin status for My Organization"   # <-- hard coded
      redirect = organization_path(params[:pending_organization_id])
    else
      notice = "You have approved #{user.email}."
      redirect = users_path
    end
    user.update_attributes(params)
    flash[:notice] = notice
    redirect_to(redirect)
  end

  def index
    if !current_user.admin?
      #flash[:notice] = "You must be signed in as an admin to perform this action!"
      redirect_to root_path
      flash[:notice] = "You must be signed in as an admin to perform this action!"
    else
      @users = User.all
    end
>>>>>>> Stashed changes
  end
end
