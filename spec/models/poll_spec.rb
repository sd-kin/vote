# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Poll, type: :model do
  it 'not be valid without title and options' do
    expect(FactoryGirl.build(:poll)).to_not be_valid
  end

  it 'not be valid without title' do
    expect(FactoryGirl.build(:poll, :with_options)).to_not be_valid
  end

  it 'be valid with title and options' do
    expect(FactoryGirl.build(:valid_poll)).to be_valid
  end

  it 'change valid poll status to ready' do
    poll = FactoryGirl.create(:valid_poll)
    poll.ready!
    expect(poll).to be_ready
  end

  it 'not change non valid poll status to ready' do
    poll = FactoryGirl.create(:poll, :with_title)
    poll.ready!
    expect(poll).not_to be_ready
  end

  it 'change poll status from ready to draft when all options deleted' do
    poll = FactoryGirl.create(:valid_poll)
    poll.ready!
    poll.options.destroy_all
    poll.touch
    expect(poll).not_to be_ready
  end

  it 'have rating' do
    expect(FactoryGirl.create(:valid_poll).rating.value).to eq(0)
  end

  context 'when create poll' do
    it 'increase counter' do
      expect { FactoryGirl.create(:valid_poll) }.to change { Poll.count }.by(1)
    end

    it 'have owner id' do
      expect(FactoryGirl.create(:valid_poll).user_id).to_not be_nil
    end
  end
end
