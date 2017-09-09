# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Polls::Update do
  let(:service_call) { Services::Polls::Update.call(poll, params) }
  let(:poll)         { FactoryGirl.create :valid_poll }
  let(:params)       { ActionController::Parameters.new(poll: poll_params) }

  context 'when poll params correct' do
    let(:poll_params) { FactoryGirl.attributes_for :valid_poll }

    it 'changes poll title' do
      expect { service_call }.to change { poll.title }.from(poll.title).to(poll_params[:title])
    end
  end

  context 'when poll params correct' do
    let(:poll_params) { { title: '' } }

    it 'not changes poll title' do
      expect { service_call }.to_not change { poll.reload.title }
    end
  end
end
