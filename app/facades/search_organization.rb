module Facades
  class SearchOrganization < Struct.new(:query_term, :organizations, :category, :category_options, :json)
  end
end
