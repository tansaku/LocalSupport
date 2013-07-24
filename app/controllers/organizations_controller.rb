class OrganizationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:search, :index, :show]

  def search
    query_term = params[:q]
    category_id = params["category"]["id"] if !params["category"].nil? && !params["category"]["id"].blank?
    Services::SearchOrganization.new(self).call(query_term, category_id)
  end

  def index
    organizations = Organization.recent
    @presenter = Facades::SearchOrganization.new('',organizations, '',
                                              init_category_options,gmap4rails_with_popup_partial(organizations, 'popup'))
    organization_render_formats(organizations)
  end

  def show
    @organization = Organization.find(params[:id])
    @editable = current_user.can_edit?(@organization) if current_user
    @json = gmap4rails_with_popup_partial(@organization,'popup')
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @organization }
    end
  end

  def new
    @organization = Organization.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @organization }
    end
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def create
    # model filters for logged in users, but we check here if that user is an admin
    # TODO refactor that to model responsibility?
    unless current_user.try(:admin?)
      flash[:notice] = "You don't have permission"
      redirect_to organizations_path and return false
    end
    @organization = Organization.new(params[:organization])

    respond_to do |format|
      if @organization.save
        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
        format.json { render json: @organization, status: :created, location: @organization }
      else
        format.html { render action: "new" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @organization = Organization.find(params[:id])
    unless current_user.try(:can_edit?,@organization)
      flash[:notice] = "You don't have permission"
      redirect_to organization_path(params[:id]) and return false
    end
    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    unless current_user.try(:admin?)
      flash[:notice] = "You don't have permission"
      redirect_to organization_path(params[:id]) and return false
    end
    @organization = Organization.find(params[:id])
    @organization.destroy

    respond_to do |format|
      format.html { redirect_to organizations_url }
      format.json { head :ok }
    end
  end

  private
  def gmap4rails_with_popup_partial(item, partial)
    item.to_gmaps4rails  do |org, marker|
      marker.infowindow render_to_string(:partial => partial, :locals => { :@org => org})
    end
  end

  def search_organization_with_results(term, organizations, category)
    @presenter = Facades::SearchOrganization.new(term, organizations, category, 
                                              init_category_options, 
                                              gmap4rails_with_popup_partial(organizations, 'popup'))
    organization_render_formats(organizations)
  end

  def organization_render_formats(organizations)
    respond_to do |format|
      format.html { render :template =>'organizations/index'}
      format.json { render json:  organizations }
      format.xml  { render :xml => organizations }
    end
  end

  def search_organization_without_results(organizations)
    flash.now[:alert] = "Sorry, it seems we don't quite have what you are looking for." if organizations.empty?
  end

  def init_category_options
    Category.first_charities.collect {|c| [ c.name, c.id ] }
  end
end
