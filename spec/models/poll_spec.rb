# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Poll, type: :model do
  let(:poll) { FactoryGirl.create(:valid_poll) }
  let(:voted_poll) { FactoryGirl.create :valid_poll, :voted }
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

  context 'when update poll' do
    subject { voted_poll.update_attribute(:title, 'updated_title!') }

    it 'change title' do
      expect { subject }.to change { voted_poll.title }.to('updated_title!')
    end

    it 'drop votation progress' do
      subject

      expect(poll.reload.vote_results).to be_empty
      expect(poll.reload).to be_draft
    end
  end

  it 'should have default maximum number of voters' do
    expect(poll.max_voters).to eq(Float::INFINITY)
  end

  it 'should have no voters' do
    expect(poll.voters).to eq([])
  end

  it 'raise error when try to add voter twice' do
    expect { voted_poll.voters << voted_poll.voters.first }.to raise_error(ActiveRecord::RecordInvalid)
  end

  context 'maximum voters' do
    it 'should be closed when reach maximum voters limit' do
      voted_poll.max_voters = 2
      voted_poll.vote!(user2, [2, 1, 0])

      expect(voted_poll.reload).to be_finished
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
      poll.finish!

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
        expect(poll.able_to_ready?).to be_truthy
      end

      it 'able to be deleted' do
        expect(poll.able_to_delete?).to be_truthy
      end

      it 'not able to be finished' do
        expect(poll.able_to_finish?).to be_falsey
      end
    end

    context 'when poll ready' do
      let(:poll) { FactoryGirl.create :valid_poll, status: 'ready' }

      it 'have status ready' do
        expect(poll).to be_ready
      end

      it 'able to be draft' do
        expect(poll.able_to_draft?).to be_truthy
      end

      it 'able to be deleted' do
        expect(poll.able_to_delete?).to be_truthy
      end

      it 'able to be finished' do
        expect(poll.able_to_finish?).to be_truthy
      end
    end

    context 'when poll finished' do
      let(:poll) { FactoryGirl.create :valid_poll, status: 'finished' }

      it 'have status finished' do
        expect(poll).to be_finished
      end

      it 'able to be draft' do
        expect(poll.able_to_draft?).to be_truthy
      end

      it 'able to be deleted' do
        expect(poll.able_to_delete?).to be_truthy
      end

      it 'not able to be ready' do
        expect(poll.able_to_ready?).to be_falsey
      end
    end

    context 'when poll deleted' do
      let(:poll) { FactoryGirl.create :valid_poll, status: 'deleted' }

      it 'have status deleted' do
        expect(poll).to be_deleted
      end

      it 'able to be draft' do
        expect(poll.able_to_draft?).to be_truthy
      end

      it 'not able to be ready' do
        expect(poll.able_to_ready?).to be_falsey
      end

      it 'not able to be finished' do
        expect(poll.able_to_finish?).to be_falsey
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

    context 'ready -> draft' do
      subject { voted_poll.draft! }

      context 'drop votation history' do
        it 'have empty current state' do
          subject

          expect(voted_poll.current_state).to be_empty
        end

        it 'have no vote results' do
          subject

          expect(voted_poll.vote_results).to be_empty
        end

        it 'have no voters' do
          subject

          expect(voted_poll.voters).to be_empty
        end

        it 'dissapear from users voted polls' do
          user = voted_poll.voters.first
          poll.status = 'ready'
          poll.vote!(user, [0, 1, 2])

          expect(user.voted_polls).to match_array([voted_poll, poll])

          subject

          expect(user.reload.voted_polls).to match_array([poll])
        end
      end
    end

    context 'ready -> finished' do
      subject { voted_poll.finish! }

      it 'keep votation progress' do
        subject

        expect(voted_poll.voters).to_not be_empty
      end
    end
  end

  context 'draft poll when' do
    let(:poll) { FactoryGirl.create :valid_poll, status: 'ready' }

    it 'create option' do
      expect { poll.options.create(title: 'new_option', description: 'blah blah') }.to change { poll.reload.status }.from('ready').to('draft')
    end

    it 'update option' do
      expect { poll.options.first.update_attribute(:title, 'updated title') }.to change { poll.reload.status }.from('ready').to('draft')
    end
    it 'delete option' do
      expect { poll.options.first.destroy }.to change { poll.reload.status }.from('ready').to('draft')
    end
  end
end
