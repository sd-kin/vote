# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Services::Polls::Creation do

  let(:service_call) { Services::Polls::Creation.call(current_user, params) }
  let!(:current_user) { FactoryGirl.create(:user) }
  let(:params){ActionController::Parameters.new(poll: poll_params, options: options_params)}

  context 'when poll parameters valid' do
    let(:poll_params){ FactoryGirl.attributes_for(:valid_poll) }

    context 'and options parameters valid' do
      let(:options_params){ [FactoryGirl.attributes_for(:valid_option), FactoryGirl.attributes_for(:valid_option), FactoryGirl.attributes_for(:valid_option) ]}

      it 'creates poll' do
        expect{poll = service_call}.to change{Poll.count}.by(1)
      end

      it 'creates options' do

      end

      it 'has no errors' do

      end
    end

    context 'and options parameters invalid' do

    end
  end

  context 'when poll parameters invalid' do
    context 'and options parameters valid' do

    end

    context 'and options parameters invalid' do

    end
  end
end