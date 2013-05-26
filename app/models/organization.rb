require 'csv'

class Organization < ActiveRecord::Base
  acts_as_gmappable :check_process => false

  #This method is overridden to save organization if address was failed to geocode
  def run_validations!
    run_callbacks :validate
    remove_errors_with_address
    errors.empty?
  end

  def self.search_by_keyword(keyword)
    self.where("description LIKE ?","%#{keyword}%")
  end
  
  def gmaps4rails_address
    "#{self.address}, #{self.postcode}"
  end

  def gmaps4rails_infowindow
    "#{self.name}"
  end

  def self.humanize_description(unfriendly_description) 
    unfriendly_description && unfriendly_description.humanize
  end

  def self.parse_address(address_with_trailing_postcode)  
    address = address_with_trailing_postcode.to_s
    postcode = ''
    match = address_with_trailing_postcode.to_s.match(/(.*)(,\s*(\w\w\d\s* \d\w\w))/)
    if match
      if match.length == 4 
        address = match[1]
        postcode = match[3].to_s
      end
    end
    {:address => address, :postcode => postcode}
  end

  #Edit this if CSV 'schema' changes
  #value is the name of a column in csv file
  @@COLUMN_MAPPINGS = {
      name: 'Title',
      address: 'Contact Address',
      description: 'Activities',
      website: 'website',
      telephone: 'Contact Telephone',
      date_removed: 'date removed'
  }

  def self.create_from_array(row, validate = true)
    check_columns_in(row)
    return nil if row[@@COLUMN_MAPPINGS[:date_removed]]
    address = self.parse_address(row[@@COLUMN_MAPPINGS[:address]])

    org = Organization.new
    org.name = row[@@COLUMN_MAPPINGS[:name]].to_s.humanized_all_first_capitals
    org.description = self.humanize_description(row[@@COLUMN_MAPPINGS[:description]])
    org.address = address[:address].humanized_all_first_capitals
    org.postcode = address[:postcode]
    org.website = row[@@COLUMN_MAPPINGS[:website]]
    org.telephone = row[@@COLUMN_MAPPINGS[:telephone]]

    org.save! validate: validate

    org
  end

  def self.import_addresses(filename, limit, validate = true)
    csv_text = File.open(filename, 'r:ISO-8859-1')
    count = 0
    CSV.parse(csv_text, :headers => true).each do |row|
      if count >= limit
        break
      end
      count += 1
      self.create_from_array(row, validate)
    end
  end

  def self.check_columns_in(row)
    @@COLUMN_MAPPINGS.each_value do |column_name|
      unless row.header?(column_name)
        raise CSV::MalformedCSVError, "No expected column with name #{column_name} in CSV file"
      end
    end
  end

  private

  def remove_errors_with_address
    errors_hash = errors.to_hash
    errors.clear
    errors_hash.each do |key, value|
      if key.to_s != 'gmaps4rails_address'
        errors.add(key, value)
      else
        # nullify coordinates
        self.latitude = nil
        self.longitude = nil
      end
    end
  end
end

class String
  def humanized_all_first_capitals
    self.humanize.split(' ').map{|w| w.capitalize}.join(' ')
  end
end
