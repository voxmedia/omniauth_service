require_relative '../test_helper'

describe OmniauthService do

  it "must have a version" do
    assert !OmniauthService::VERSION.nil?
  end

end
