require 'spec_helper'

describe Meal do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Meal.create!(@valid_attributes)
  end
end
