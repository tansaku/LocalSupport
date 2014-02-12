module OrganizationReportsHelper
  # Tested functionally in orphans controller spec
  def retrieve_password_url(token)
    Rails.application.routes.url_helpers.edit_user_password_path(reset_password_token: token, only_path: false, host: request.host)
  end
end