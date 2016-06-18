# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Poll, type: :model do
  it 'shold not be valid without title and options' do
    expect(FactoryGirl.build(:poll)).to_not be_valid
  end

  it 'should not be valid without title' do
    expect(FactoryGirl.build(:poll, :with_options)).to_not be_valid
  end

  it 'should be valid with title and options' do
    expect(FactoryGirl.build(:valid_poll)).to be_valid
  end

  it 'should increase counter' do
    expect { FactoryGirl.create(:valid_poll) }.to change { Poll.count }.by(1)
  end

  it 'should change valid poll status to ready' do
    poll = FactoryGirl.create(:valid_poll)
    poll.ready!
    expect(poll).to be_ready
  end

  it 'should not change non valid poll status to ready' do
    poll = FactoryGirl.create(:poll, :with_title)
    poll.ready!
    expect(poll).not_to be_ready
  end

  it 'should change poll status from ready to draft when all options deleted' do
    poll = FactoryGirl.create(:valid_poll)
    poll.ready!
    poll.options.destroy_all
    poll.touch
    expect(poll).not_to be_ready
  end
end
