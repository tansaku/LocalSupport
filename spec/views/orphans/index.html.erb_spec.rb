require 'spec_helper'

describe "orphans/index.html.erb" do
  let(:org1) { stub_model Organization, name: 'test', address: '12 pinner rd', email: 'hello@there.com', users: [] }
  before(:each) { assign(:orphans, [org1]) }
end