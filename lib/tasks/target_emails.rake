# rake db:target_emails
require 'csv'
namespace :db do
  task :target_emails => :environment do
    orgs = Organization.find_orphan_organizations
    CSV.open("db/target_emails.csv", "wb") do |csv|
      orgs.each do |org|
        token = User.find_by_email(org.email).reset_password_token
        reset_path = Rails.application.routes.url_helpers.edit_user_password_path(initial: true, reset_password_token: token )
        csv << [org.name, org.email, reset_path] 
      end
    end
  end
end
