# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user1) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:user3) { FactoryGirl.create(:user) }

  context 'GET#index' do
    subject { get :index }

    it 'should be success' do
      expect(subject).to be_success
    end

    it 'should get all users' do
      subject
      expect(assigns(:users)).to match_array([user1, user2, user3])
    end
  end

  context 'GET#new' do
    subject { get :new }
    it 'should be success' do
      expect(subject).to be_success
    end

    it 'should build new user' do
      subject
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  context 'POST#create' do
    context 'when success' do
      subject { post :create, user: FactoryGirl.attributes_for(:user) }

      it 'should redirect to ready polls' do
        expect(subject).to redirect_to(ready_polls_path)
      end

      it 'should create user' do
        expect { subject }.to change { User.count }.by(1)
      end
    end

    context 'when not success' do
      subject { post :create, user: FactoryGirl.attributes_for(:user, username: '') }

      it 'should render template new' do
        expect(subject).to render_template(:new)
      end
    end
  end

  context 'GET#edit' do
    subject { get :edit, id: user1.id }

    it 'should be success' do
      expect(subject).to be_success
    end

    it 'should not build new user' do
      subject
      expect(assigns(:user)).not_to be_a_new(User)
    end
  end

  context 'GET#show' do
    subject { get :show, id: user1.id }

    it 'should be success' do
      expect(subject).to be_success
    end

    it 'should get correct user' do
      subject
      expect(assigns(:user)).to eq(user1)
    end
  end
end
