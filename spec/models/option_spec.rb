require 'rails_helper'

RSpec.describe Option, type: :model do
  it 'should not be valid without title and description' do
    expect(FactoryGirl.build(:option)).to_not be_valid
  end

  it 'should not be valid without title' do
    expect(FactoryGirl.build(:option, :with_description)).to_not be_valid
  end

  it 'should not be valid without description' do
    expect(FactoryGirl.build(:option, :with_title)).to_not be_valid
  end

  it 'should be valid with title and description' do
    expect(FactoryGirl.build(:valid_option)).to be_valid
  end
end
