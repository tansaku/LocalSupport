module ApplicationHelper
  def site_title
    if SiteName.first.nil?
      "Harrow Community Network"
    else
      SiteName.first.site_name
    end
  end
end
