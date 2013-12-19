# rake db:target_emails['target_emails.csv']
# To undo user creation: User.where("created_at > ?", 1.day.ago).each {|u| u.destroy}
# Possible pre-processing steps: Organization.all.each {|o| o.email = o.email.strip if o.email; o.save!}
#                             : Organization.update_all('email = LOWER(email)')
require 'csv'
namespace :db do
  task :target_emails, [:file] => :environment do |_, args|
    users = Organization.find_users_for_orphan_organizations
    #require_relative "../../db/csv/"
    args[:file] ||=  'target_emails.csv'
    CSV.open("db/csv/"+args[:file], "wb") do |csv|
      users.each do |user|
       unless user.nil?
          puts "writing line for user: #{user.email}"
          token = user.reset_password_token
          reset_path = Rails.application.routes.url_helpers.edit_user_password_path(initial: true, reset_password_token: token)
          csv << [user.organization.try(:name), user.email, reset_path]
       end
      end
    end
  end
end

