# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Poll, type: :model do
  let(:poll) { FactoryGirl.create(:valid_poll) }
  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }

  it 'shold not be valid without title and options' do
    expect(FactoryGirl.build(:poll)).to_not be_valid
  end

  it 'should not be valid without title' do
    expect(FactoryGirl.build(:poll, :with_options)).to_not be_valid
  end

  it 'should be valid with title and options' do
    expect(FactoryGirl.build(:valid_poll)).to be_valid
  end

  it 'should change valid poll status to ready' do
    poll.ready!
    expect(poll).to be_ready
  end

  it 'should not change non valid poll status to ready' do
    poll = FactoryGirl.create(:poll, :with_title)
    poll.ready!
    expect(poll).not_to be_ready
  end

  it 'should change poll status from ready to draft when all options deleted' do
    poll.ready!
    poll.options.destroy_all
    poll.touch
    expect(poll).not_to be_ready
  end

  it 'should have rating' do
    expect(FactoryGirl.create(:valid_poll).rating.value).to eq(0)
  end

  context 'when create poll' do
    it 'should increase counter' do
      expect { FactoryGirl.create(:valid_poll) }.to change { Poll.count }.by(1)
    end

    it 'should have owner id' do
      expect(FactoryGirl.create(:valid_poll).user_id).to_not be_nil
    end
  end

  it 'should have default maximum number of voters' do
    expect(poll.max_voters).to eq(Float::INFINITY)
  end

  it 'should have no voters' do
    expect(poll.voters).to eq([])
  end

  it 'raise error when try to add voter twice' do
    poll.voters << user

    expect { poll.voters << user }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should be closed when reach maximum voters limit' do
    poll.max_voters = 2

    poll.vote!(user: user, preferences: [0, 1, 2])
    poll.vote!(user: user2, preferences: [2, 1, 0])

    expect(poll).to be_closed
  end

  it 'should have expiration date in future' do
    poll.expire_at = 1.year.ago
    expect { poll.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
