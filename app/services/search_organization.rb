module Services
  class SearchOrganization < Struct.new(:listener)

    def call(term, category_id)
      category = Category.find_by_id(category_id) unless category_id
      organizations = Organization.search_by_keyword(term).filter_by_category(category_id)
      listener.search_organization_without_results(organizations)
      listener.search_organization_with_results(term, organizations, category)
    end

  end
end
