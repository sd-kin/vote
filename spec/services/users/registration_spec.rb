# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Services::Users::Registration do
  it 'redirect .call to #call' do
    arguments = [:current_user, :user_params]
    expect_any_instance_of(Services::Users::Registration).to receive(:call).with(*arguments)
    Services::Users::Registration.call(*arguments)
  end

  context 'when user params valid' do
    let!(:current_user) { User.create_anonimous! }
    let(:user_params)   { FactoryGirl.attributes_for(:user) }

    it 'return successful result' do
      expect(Services::Users::Registration.call(current_user, user_params).errors).to be_empty
    end

    it 'not increase users counter' do
      expect { Services::Users::Registration.call(current_user, user_params) }.to_not change { User.count }
    end

    it 'remove anonymous status' do
      expect(Services::Users::Registration.call(current_user, user_params)).to_not be_anonimous
    end

    it 'call account activation mailer' do
      expect(UserMailer).to receive(:account_activation).once.and_call_original

      Services::Users::Registration.call(current_user, user_params)
    end

    context 'and current user already registered' do
      let!(:current_user) { FactoryGirl.create(:user) }

      it 'return successful result' do
        expect(Services::Users::Registration.call(current_user, user_params).errors).to be_empty
      end

      it 'increase users counter' do
        expect { Services::Users::Registration.call(current_user, user_params) }.to change { User.count }.by(1)
      end

      it 'return not anonymous user' do
        expect(Services::Users::Registration.call(current_user, user_params)).to_not be_anonimous
      end

      it 'call account activation mailer' do
        expect(UserMailer).to receive(:account_activation).once.and_call_original

        Services::Users::Registration.call(current_user, user_params)
      end
    end
  end

  context 'when user params invalid' do
    let(:current_user) { User.create_anonimous! }
    let(:user_params)  { FactoryGirl.attributes_for(:user, email: '') }

    it 'return result with errors' do
      expect(Services::Users::Registration.call(current_user, user_params).errors).to be_any
    end

    it 'not remove anonymous status' do
      expect(Services::Users::Registration.call(current_user, user_params)).to be_anonimous
    end

    it 'do not call account activation mailer' do
      expect(UserMailer).to_not receive(:account_activation)

      Services::Users::Registration.call(current_user, user_params)
    end
  end
end
