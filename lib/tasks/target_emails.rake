# rake db:target_emails['db/csv/target_emails.csv']
require 'csv'
namespace :db do
  task :target_emails, [:file] => :environment do |_, args|
    users = Organization.find_users_for_orphan_organizations
    #require_relative "../../db/csv/"
    CSV.open("db/csv/" + args[:file], "wb") do |csv|
      users.each do |user|
        token = user.reset_password_token
        reset_path = Rails.application.routes.url_helpers.edit_user_password_path(initial: true, reset_password_token: token)
        csv << [user.organization.name, user.email, reset_path]
      end
    end
  end
end

