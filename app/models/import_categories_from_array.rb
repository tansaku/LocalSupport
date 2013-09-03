class ImportCategoriesFromArray
  def initialize(row, mappings)
    @row = row
    @mappings = mappings
  end

  def call
    check_columns_in(@row)
    org_name = FirstCapitalsHumanizer.call(row[@mappings[:name]])
    org = Organization.find_by_name(org_name)
    check_categories_for_import(row, org)
    org
  end
end
