# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Polls::Update do
  let(:service_call) { Services::Polls::Update.call(poll, params) }
  let(:poll)         { FactoryGirl.create :valid_poll }
  let(:params)       { ActionController::Parameters.new(poll: poll_params) }

  context 'Change title' do
    context 'when params correct' do
      let(:poll_params) { FactoryGirl.attributes_for :valid_poll }

      it 'changes' do
        expect { service_call }.to change { poll.title }.from(poll.title).to(poll_params[:title])
      end
    end

    context 'when params incorrect' do
      let(:poll_params) { { title: '' } }

      it 'not changes' do
        expect { service_call }.to_not change { poll.reload.title }
      end
    end
  end

  context 'Change status' do
    let(:poll_params) { FactoryGirl.attributes_for :valid_poll }

    context 'when status parameter persist' do
      let(:params) { ActionController::Parameters.new(poll: poll_params, status: 'ready') }

      it 'changes' do
        expect { service_call }.to change { poll.status }.from('draft').to('ready')
      end
    end

    context 'when status parameter not persist' do
      it 'do not changes' do
        expect { service_call }.to_not change { poll.status }
      end
    end
  end
end
