# rake db:target_emails
require 'csv'
namespace :db do
  task :target_emails => :environment do
    users = Organization.find_users_for_orphan_organizations
    CSV.open("db/target_emails.csv", "wb") do |csv|
      users.each do |user|
        token = user.reset_password_token
        reset_path = Rails.application.routes.url_helpers.edit_user_password_path(initial: true, reset_password_token: token )
        csv << [user.organization.name, user.email, reset_path] 
      end
    end
  end
end
