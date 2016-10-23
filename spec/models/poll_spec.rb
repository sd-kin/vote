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
    expect(poll.reload).to be_ready
  end

  it 'should not change poll with no options status to ready' do
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

  context 'maximum voters' do
    it 'should be closed when reach maximum voters limit' do
      poll.max_voters = 2
      poll.ready!
      poll.reload
      poll.vote!(user, [0, 1, 2])
      poll.vote!(user2, [2, 1, 0])

      expect(poll.reload).to be_finished
    end

    it 'should not save infinity value to db' do
      poll.max_voters = 1.0 / 0
      poll.save

      expect(poll.reload[:max_voters]).to be_nil
    end

    it 'never set max_voters to infinity' do
      poll.max_voters = 1.0 / 0
      expect(poll[:max_voters]).to be_nil
    end

    it 'should be valid when nill' do
      poll = Poll.new(title: 'test', max_voters: nil, expire_at: 1.year.from_now)

      expect(poll).to be_valid
    end
  end

  context 'expiration date' do
    it 'should have expiration date in future' do
      poll.expire_at = 1.year.ago
      expect { poll.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'shold have error when reopen outdated' do
      poll.update_attribute(:expire_at, 1.year.ago)
      poll.finished!

      expect(poll.errors[:expire_at]).to eq(['should be in future'])
    end

    it 'should close polls with expiration date in past' do
      poll.ready!
      poll.update_attribute(:expire_at, 1.year.ago)

      expect { poll.reload }.to change { poll.status }.to('finished')
    end
  end

  context 'comments' do
    it 'should have comments' do
      expect(poll.comments).to eq([])
    end
  end

  context 'check availible transitions' do
    context 'when poll draft' do
      it 'have status draft' do
        expect(poll).to be_draft
      end

      it 'able to be ready' do
        expect(poll.can_be_ready?).to be_truthy
      end

      it 'able to be deleted' do
        expect(poll.can_be_deleted?).to be_truthy
      end

      it 'not able to be finished' do
        expect(poll.can_be_finished?).to be_falsey
      end
    end

    context 'when poll ready' do
      let(:poll) { FactoryGirl.create :valid_poll, status: 'ready' }

      it 'have status ready' do
        expect(poll).to be_ready
      end

      it 'able to be draft' do
        expect(poll.can_be_draft?).to be_truthy
      end

      it 'able to be deleted' do
        expect(poll.can_be_deleted?).to be_truthy
      end

      it 'able to be finished' do
        expect(poll.can_be_finished?).to be_truthy
      end
    end

    context 'when poll finished' do
      let(:poll) { FactoryGirl.create :valid_poll, status: 'finished' }

      it 'have status finished' do
        expect(poll).to be_finished
      end

      it 'able to be draft' do
        expect(poll.can_be_draft?).to be_truthy
      end

      it 'able to be deleted' do
        expect(poll.can_be_deleted?).to be_truthy
      end

      it 'not able to be ready' do
        expect(poll.can_be_ready?).to be_falsey
      end
    end

    context 'when poll deleted' do
      let(:poll) { FactoryGirl.create :valid_poll, status: 'deleted' }

      it 'have status deleted' do
        expect(poll).to be_deleted
      end

      it 'able to be draft' do
        expect(poll.can_be_draft?).to be_truthy
      end

      it 'not able to be ready' do
        expect(poll.can_be_ready?).to be_falsey
      end

      it 'not able to be finished' do
        expect(poll.can_be_finished?).to be_falsey
      end
    end
  end

  context 'Check changing status callbacks.' do
    context 'draft -> ready' do
      let(:poll) { FactoryGirl.create :poll, :with_title }

      it 'stay draft if poll have no options' do
        poll.ready!

        expect(poll).to be_draft
      end

      it 'have an error if poll have no options' do
        expect { poll.ready! }.to change { poll.errors.count }.by(1)
      end
    end
  end
end
