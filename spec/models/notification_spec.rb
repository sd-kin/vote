# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:poll) { FactoryGirl.create :valid_poll, :voted, status: 'ready' }

  context 'Poll notifications.' do
    context 'When poll finished' do
      it 'should notificate author' do
        expect { poll.finish! }.to change { poll.user.notifications.count }.by(1)
        expect(poll.user.notifications.first.message).to eq('Your poll was finished')
      end

      it 'should notificate users who vote' do
        expect { poll.finish! }.to change { poll.voters.first.notifications.count }.by(1)
        expect(poll.voters.first.notifications.first.message).to eq('Poll, your voted for, was closed')
      end
    end
  end

  context 'Comment notifications.' do
  end
end
