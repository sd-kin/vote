require 'rails_helper'

RSpec.describe Poll, type: :model do
  it 'shold not be valid without title and options' do
    expect(FactoryGirl.build(:poll)).to_not be_valid
  end

  it 'shold not be valid without title but with option' do
    expect(FactoryGirl.build(:poll, :with_title)).to_not be_valid
  end

  it 'should not be valid without options but with title' do
    expect(FactoryGirl.build(:poll, :with_options)).to_not be_valid
  end

  it 'should be valid with title and options' do
    expect(FactoryGirl.build(:valid_poll)).to be_valid
  end

  it 'should increase counter' do
    expect { FactoryGirl.create(:valid_poll) }.to change { Poll.count }.by(1)
  end
end