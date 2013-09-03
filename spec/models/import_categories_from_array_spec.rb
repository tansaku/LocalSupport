require_relative '../../app/models/import_categories_from_array'

describe ImportCategoriesFromArray,"#call" do 
  let(:row) { Hash.new }
  let(:mappings) { Hash.new }
  let(:service) { ImportCategoriesFromArray.new(row, mappings) }

  subject { service.call }

  it { should == "" } 
end
