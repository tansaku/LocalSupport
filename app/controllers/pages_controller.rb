class PagesController < ApplicationController

  # Withholding this functionality until we decide how to implement an admin 'dashboard'
  #include ApplicationHelper
  #before_filter :authorize, :except => :show

  # GET /pages
  # GET /pages.json
  #TODO Hide all but show and edit
  def index
    @pages = Page.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pages }
    end
  end

  # GET /pages/:permalink
  # GET /pages/:permalink.json
  def show
    @admin = current_user.admin? if current_user
    # find_by_permalink! returns 404 if no match
    @page = Page.find_by_permalink!(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.json
  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @page }
    end
  end

  # GET /pages/:permalink/edit
  def edit
    @page = Page.find_by_permalink!(params[:id])
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render json: @page, status: :created, location: @page }
      else
        format.html { render action: "new" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pages/:permalink
  # PUT /pages/:permalink.json
  def update
    @page = Page.find_by_permalink!(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/:permalink
  # DELETE /pages/:permalink.json
  def destroy
    @page = Page.find_by_permalink!(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to pages_url }
      format.json { head :no_content }
    end
  end
end
