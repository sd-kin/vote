# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  context 'GET#index' do
    let!(:user1) { FactoryGirl.create(:user) }
    let!(:user2) { FactoryGirl.create(:user) }
    let!(:user3) { FactoryGirl.create(:user) }

    it 'should be success' do
      expect(get :index).to be_success
    end

    it 'should get all users' do
      get :index
      expect(assigns(:users)).to match_array([user1, user2, user3])
    end
  end

  context 'GET#new' do
    it 'should be success' do
      expect(get :new).to be_success
    end

    it 'should build new user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end
end
