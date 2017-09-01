# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'account_activation' do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.account_activation(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Account activation')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreplay@vote.test'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi')
    end
  end

  describe 'password_reset' do
    let(:user) { FactoryGirl.create(:user, reset_token: SecureRandom.urlsafe_base64) }
    let(:mail) { UserMailer.password_reset(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Password reset')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreplay@vote.test'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi')
    end
  end
end
