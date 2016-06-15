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

  describe 'when add votation result' do
    before(:all) do
      @poll = FactoryGirl.create(:valid_poll)
      preferences = @poll.options.ids.map { |id| 'option_' + id.to_s }.reverse
      @poll.save_preferences_as_weight(preferences)
    end

    it 'should save preferences as weights' do
      expect(@poll.vote_results.first).to eq([0, 1, 2])
    end

    it 'should save correct current state' do
      @poll.vote!

      expect(@poll.options_in_rank).to eq(Hash[[0, 1, 2].zip(@poll.options.ids.map { |x| [x] })])
    end

    it 'should increase count of saved results' do
      preferences = @poll.options.ids.map { |id| 'option_' + id.to_s }.shuffle

      expect { @poll.save_preferences_as_weight(preferences) }.to change { @poll.vote_results.count }.by(1)
    end
  end
end
