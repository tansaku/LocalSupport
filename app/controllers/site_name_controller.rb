class SiteNameController < ApplicationController
  def edit
    if not request.post?
      render 'site_name/edit'
    else
      s = nil
      if SiteName.count != 0
        s = SiteName.first
      else
        s = SiteName.new
      end

      s.site_name = params[:site_name]
      s.save!

      redirect_to "/"
    end
  end
end