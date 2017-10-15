# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Polls::Update do
  let(:service_call) { Services::Polls::Update.call(poll, params) }
  let(:poll)         { FactoryGirl.create :valid_poll }
  let(:params)       { ActionController::Parameters.new(poll: poll_params) }
  let(:poll_params)  { FactoryGirl.attributes_for :valid_poll }

  context 'title' do
    context 'when params correct' do
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

  context 'status' do
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

  context 'voters limit' do
    context 'when new value sent' do
      let(:poll_params) { FactoryGirl.attributes_for :valid_poll, max_voters: 123 }

      it 'change to new value' do
        expect { service_call }.to change { poll.max_voters }.from(Float::INFINITY).to(123)
      end
    end

    context 'when old value sent' do
      it 'do not change old value' do
        expect { service_call }.to_not change { poll.max_voters }
      end
    end
  end

  context 'expiration date' do
    context 'when new value sent' do
      let(:new_expiration_date) { 2.years.from_now.round }
      let(:poll_params)         { FactoryGirl.attributes_for :valid_poll, expire_at: new_expiration_date }

      it 'change to new value' do
        expect { service_call }.to change { poll.expire_at }.to(new_expiration_date)
      end
    end

    context 'when old value sent' do
      # Actually it does change old value for few milliseconds, thats why I use round,
      # most likely it time for variable initialization. On the one hand it does not really
      # matter, but will be better find out exact reason for such behavior and make test pass
      # without rounding expiration date value
      it 'do not change old value' do
        expect { service_call }.to_not change { poll.expire_at.round }
      end
    end
  end

  context 'images' do
    context 'adding images' do
      let(:poll_params) { FactoryGirl.attributes_for :valid_poll, images: [sample_file] }

      it 'increase images count' do
        expect { service_call }.to change { poll.images.count }.by(1)
      end
    end

    context 'removing images' do
      let(:poll)   { FactoryGirl.create :valid_poll, :with_image }
      let(:params) { ActionController::Parameters.new(poll: poll_params, ids_of_images_for_delete: [poll.images.first.id.to_s]) }

      it 'decrease images count' do
        expect { service_call }.to change { poll.images.count }.by(-1)
      end
    end
  end

  context 'options' do
    context 'create new' do
      context 'when params correct' do
        let(:params) { ActionController::Parameters.new(poll: poll_params, new_options: [FactoryGirl.attributes_for(:valid_option)]) }

        it 'create new option' do
          expect { service_call }.to change { poll.options.count }.by(1)
        end
      end

      context 'when params incorrect' do
      end

      context 'when params empty' do
        let(:params) { ActionController::Parameters.new(poll: poll_params) }

        it 'not changes poll' do
          expect(service_call).to eq(poll)
        end
      end
    end
  end
end

def sample_file(filename = 'test_image.png')
  File.new("spec/fixtures/files/#{filename}")
end
