# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  context 'when create user' do
    it 'should create user with username and email' do
      expect { FactoryGirl.create(:user) }.to change { User.count }.by(1)
    end

    it 'should not create user without username' do
      expect { FactoryGirl.create(:user, username: '') }.to raise_exception(ActiveRecord::RecordInvalid)
    end

    it 'should not create user without email' do
      expect { FactoryGirl.create(:user, email: '') }.to raise_exception(ActiveRecord::RecordInvalid)
    end
  end
end
