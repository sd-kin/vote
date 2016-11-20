# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:poll) { FactoryGirl.create :valid_poll, :voted, status: 'ready' }

  context 'Poll notifications.' do
    context 'When poll finished' do
      it 'should notificate author' do
        expect { poll.finish! }.to change { poll.user.notifications.count }.by(1)
        expect(poll.user.notifications.first.message).to eq('Your poll was finished.')
      end

      it 'should notificate users who vote' do
        expect { poll.finish! }.to change { poll.voters.first.notifications.count }.by(1)
        expect(poll.voters.first.notifications.first.message).to eq('Poll, your voted for, was closed.')
      end
    end

    context 'when poll drafted' do
      it 'should notificate voters' do
        voters = poll.voters.to_a
        expect { poll.draft! }.to change { voters.first.notifications.count }.by(1)
        expect(voters.first.notifications.first.message).to eq('Votation progress in poll, your voted for, was cleared.')
      end
    end

    context 'when poll have new comment' do
      it 'should notificate author' do
        expect { poll.comments.create body: 'new comment' }.to change { poll.user.notifications.count }.by(1)
      end
    end
  end

  context 'Comment notifications.' do
    let(:user) { FactoryGirl.create :user }
    let(:comment) { poll.comments.create body: 'comment to comment', author: user }

    context 'when comment have new comment' do
      it 'should notificate author' do
        expect { comment.comments.create body: 'new comment' }.to change { comment.author.notifications.count }.by(1)
      end
    end
  end
end
