class CreateOrganizationFromArray

  def initialize(row, mappings)
    @row = row
<<<<<<< HEAD
    @mappings = normalize(mappings)
  end

  def call(validate)
    return nil if @row[@mappings[:date_removed]]
    return nil if Organization.find_by_name(organization_name)

    org = build_organization(organization_name)
=======
    @mappings = mappings
  end

  def call(validate)
    check_columns_in
    organization_name = FirstCapitalsHumanizer.call(@row[@mappings[:name]])
    return nil if @row[@mappings[:date_removed]]
    return nil if Organization.find_by_name(organization_name)

    org = build_organization_from_array(organization_name)
>>>>>>> 46f38c9b51bd82ca19bff1a3fc59bab11e1c5ebb

    org.save! validate: validate
    org
  end

  private
<<<<<<< HEAD
  def organization_name
    @organization_name ||= FirstCapitalsHumanizer.call(@row[@mappings[:name]])
  end

  def normalize(mappings)
    mappings.each_value do |column_name|
=======
  def check_columns_in
    @mappings.each_value do |column_name|
>>>>>>> 46f38c9b51bd82ca19bff1a3fc59bab11e1c5ebb
      unless @row.header?(column_name)
        raise CSV::MalformedCSVError, "No expected column with name #{column_name} in CSV file"
      end
    end
  end

<<<<<<< HEAD
  def build_organization(organization_name)
    address = Address.new(@row[@mappings[:address]]).parse
    org = Organization.new({
      name:organization_name, 
      address: FirstCapitalsHumanizer.call(address[:address]),
      description: DescriptionHumanizer.call((@row[@mappings[:description]])),
      postcode: address[:postcode],
      website: @row[@mappings[:website]],
      telephone: @row[@mappings[:telephone]]
    })
=======
  def build_organization_from_array(organization_name)
    org = Organization.new
    address = Address.new(@row[@mappings[:address]]).parse
    org.name = organization_name
    org.description = DescriptionHumanizer.call((@row[@mappings[:description]]))
    org.address = FirstCapitalsHumanizer.call(address[:address])
    org.postcode = address[:postcode]
    org.website = @row[@mappings[:website]]
    org.telephone = @row[@mappings[:telephone]]
    return org
>>>>>>> 46f38c9b51bd82ca19bff1a3fc59bab11e1c5ebb
  end

end

