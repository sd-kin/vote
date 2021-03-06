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

    it 'should create user only with unique email' do
      FactoryGirl.create(:user, email: 'unique@email.test')
      expect { FactoryGirl.create(:user, email: 'unique@email.test') }.to raise_exception(ActiveRecord::RecordInvalid)
    end

    it 'should have case-insensitive validation' do
      FactoryGirl.create(:user, email: 'unique@email.test')
      expect { FactoryGirl.create(:user, email: 'uNiQUe@eMail.test') }.to raise_exception(ActiveRecord::RecordInvalid)
    end

    it 'should store email in downcase' do
      user = FactoryGirl.create(:user, email: 'uNiQUe@eMail.test')
      expect(user.email).to eq('unique@email.test')
    end

    it 'should be not activated' do
      expect(FactoryGirl.create(:user)).to_not be_activated
    end

    it 'should have activation token' do
      expect(FactoryGirl.create(:user).activation_token).to_not be_nil
    end

    it 'should have activation digest' do
      expect(FactoryGirl.create(:user).activation_digest).to_not be_nil
    end

    it 'should have no voters' do
      expect(FactoryGirl.create(:user).voted_polls).to eq([])
    end

    it 'should have rating = 0' do
      expect(FactoryGirl.create(:user).rating.value).to eq(0)
    end

    it 'should have no raters' do
      user = FactoryGirl.create(:user)
      expect(user.upvoters).to be_empty
      expect(user.downvoters).to be_empty
    end
  end

  context 'when check remember token' do
    it 'should return true if token correct' do
      user = FactoryGirl.create(:user)
      user.remember

      expect(user.correct_token?(:remember, user.remember_token)).to be_truthy
    end

    it 'should return false if token incorrect' do
      user = FactoryGirl.create(:user)
      user.remember

      expect(user.correct_token?(:remember, SecureRandom.urlsafe_base64)).to be_falsey
    end

    it 'should return false if user dont remembered' do
      user = FactoryGirl.create(:user)

      expect(user.correct_token?(:remember, user.remember_token)).to be_falsey
    end

    it 'should return false if token is nil' do
      user = FactoryGirl.create(:user)
      user.remember

      expect(user.correct_token?(:remember, nil)).to be_falsey
    end
  end

  context 'when create anonimous user' do
    it 'should increase users counter' do
      expect { User.create_anonimous! }.to change { User.count }.by(1)
    end

    it 'should be anonimous' do
      expect(User.create_anonimous!).to be_anonimous
    end
  end

  context 'when register anonimous user' do
    context 'and params correct' do
      let!(:user) { User.create_anonimous! }
      let(:user_params) { FactoryGirl.attributes_for(:user) }

      before(:each) do
        user.register(user_params)
        user.reload
      end

      it 'should not change users counter' do
        expect { user.register(user_params) }.to change { User.count }.by(0)
      end

      it 'should change users username' do
        expect(user.username).to eq(user_params[:username])
      end

      it 'should change users password' do
        expect(BCrypt::Password.new(user.password_digest).is_password?(user_params[:password])).to be_truthy
      end

      it 'should make user not anonimous' do
        expect(user.anonimous?).to be_falsey
      end
    end

    context 'and params incorrect' do
      let!(:user) { User.create_anonimous! }
      let(:user_params) { FactoryGirl.attributes_for(:user, username: '') }

      before(:each) do
        user.register(user_params)
        user.reload
      end

      it 'should not change users counter' do
        expect { user.register(user_params) }.to change { User.count }.by(0)
      end

      it 'should not change users username' do
        expect(user.username).not_to eq(user_params[:username])
      end

      it 'should not change users password' do
        expect(BCrypt::Password.new(user.password_digest).is_password?(user_params[:password])).to be_falsey
      end

      it 'user should stay anonimous' do
        expect(user.anonimous?).to be_truthy
      end
    end
  end

  context 'when register new user' do
    let!(:user) { FactoryGirl.build(:user) }
    let(:user_params) { FactoryGirl.attributes_for(:user) }

    it 'should change users counter' do
      expect { user.register(user_params) }.to change { User.count }.by(1)
    end

    it 'user should not be anonimous' do
      expect(user.anonimous?).to be_falsey
    end
  end
end
