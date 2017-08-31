# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Services::Polls::Creation do
  let(:service_call) { Services::Polls::Creation.call(current_user, params) }
  let!(:current_user) { FactoryGirl.create(:user) }
  let(:params) { ActionController::Parameters.new(poll: poll_params, options: options_params) }

  context 'when poll parameters valid' do
    let(:poll_params) { FactoryGirl.attributes_for(:valid_poll) }

    context 'and options parameters valid' do
      let(:options_params) { Array.new(3) { FactoryGirl.attributes_for(:valid_option) } }

      it 'creates poll' do
        expect { service_call }.to change { Poll.count }.by(1)
      end

      it 'creates options' do
        expect { service_call }.to change { Option.count }.by(options_params.count)
      end

      it 'has no errors' do
        poll = service_call

        expect(poll.errors).to be_empty
      end

      context 'but have empty options' do
        let(:options_params) { Array.new(3) { FactoryGirl.attributes_for(:valid_option) }.push(title: '', description: '') }

        it 'creates poll' do
          expect { service_call }.to change { Poll.count }.by(1)
        end

        it 'creates options' do
          expect { service_call }.to change { Option.count }.by(options_params.count - 1)
        end
      end

      context 'but have not enough of them' do
        let(:options_params) { Array.new(2) { FactoryGirl.attributes_for(:valid_option) } }

        it 'have error about options count' do
          poll = service_call

          expect(poll.errors.full_messages).to include("Poll should have at least #{Poll::MINIMUM_OPTIONS_COUNT} options")
        end
      end
    end

    context 'and options parameters invalid' do
      let(:options_params) { [{title: '1', description: ''}, {title: '', description: '2'},{title: '3', description: ''}] }

      it 'do not create poll' do
        expect { service_call }.to_not change { Poll.count }
      end

      it 'do not create options' do
        expect { service_call }.to_not change { Option.count }
      end

      it 'have options errors' do
        poll = service_call

        poll.options.each { |option| expect(option.errors.full_messages).to_not be_empty }
      end
    end
  end

  context 'when poll parameters invalid' do
    let(:poll_params) { FactoryGirl.attributes_for(:poll) }

    context 'and options parameters valid' do
      let(:options_params) { Array.new(3) { FactoryGirl.attributes_for(:valid_option) } }

      it 'do not create poll' do
        expect { service_call }.to_not change { Poll.count }
      end

      it 'do not create options' do
        expect { service_call }.to_not change { Option.count }
      end

      it 'poll has options errors' do
        poll = service_call

        expect(poll.errors).to_not be_empty
      end
    end

    context 'and options parameters invalid' do
      let(:options_params) { Array.new(3) { FactoryGirl.attributes_for(:option) } }

      it 'do not create poll' do
        expect { service_call }.to_not change { Poll.count }
      end

      it 'do not create options' do
        expect { service_call }.to_not change { Option.count }
      end
    end
  end
end
