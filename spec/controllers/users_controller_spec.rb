# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user1) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:user3) { FactoryGirl.create(:user) }

  context 'GET#index' do
    before(:each) { get :index }

    it 'should be success' do
      expect(response).to be_success
    end

    it 'should get all users' do
      expect(assigns(:users)).to match_array([user1, user2, user3])
    end
  end

  context 'GET#new' do
    before(:each) { get :new }
    it 'should be success' do
      expect(response).to be_success
    end

    it 'should build new user' do
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  context 'POST#create' do
    context 'when success' do
      before(:each) { post :create, user: FactoryGirl.attributes_for(:user) }

      it 'should redirect to ready polls' do
        is_expected.to redirect_to(ready_polls_path)
      end

      it 'should create user', :skip_before do
        expect { post :create, user: FactoryGirl.attributes_for(:user) }.to change { User.count }.by(1)
      end

      it 'should log in user' do
        expect(session[:user_id]).to eq(assigns(:user).id)
      end
    end

    context 'when not success' do
      before(:each) { post :create, user: FactoryGirl.attributes_for(:user, username: '') }

      it 'should render template new' do
        is_expected.to render_template(:new)
      end
    end
  end

  context 'GET#edit' do
    it 'should be success' do
      session[:user_id] = user1.id
      get :edit, id: user1.id

      expect(response).to be_success
    end

    it 'should not build new user' do
      get :edit, id: user1.id

      expect(assigns(:user)).not_to be_a_new(User)
    end

    context 'when user not current user' do
      it 'should redirect to login page if not logged in' do
        session[:user_id] = nil
        get :edit, id: user1.id

        expect(response).to redirect_to login_path
      end

      it 'should reddirect to current user edit path' do
        session[:user_id] = user2.id
        get :edit, id: user1.id

        expect(response).to redirect_to edit_user_path(user2)
      end
    end
  end

  context 'GET#show' do
    before(:each) { get :show, id: user1.id }

    it 'should be success' do
      expect(response).to be_success
    end

    it 'should get correct user' do
      expect(assigns(:user)).to eq(user1)
    end
  end

  context 'PUT#update' do
    context 'when input correct' do
      it 'should redirect to show page' do
        session[:user_id] = user1.id
        expect(put :update, id: user1.id, user: { username: user1.username, email: user1.email }).to redirect_to(user_path)
      end

      it 'should change only user username' do
        session[:user_id] = user2.id
        put :update, id: user2.id, user: { username: 'newname', email: user2.email }
        expect(assigns(:user).username).to eq("newname")
      end

      it 'should change user username' do
        session[:user_id] = user2.id
        put :update, id: user2.id, user: { username: user2.username, email: 'new@mail' }
        expect(assigns(:user).email).to eq("new@mail")
      end

      it 'should not change anything if nothing changed' do
        session[:user_id] = user1.id
        put :update, id: user1.id, user: { username: user1.username, email: user1.email }
        expect(assigns(:user)).to eq(user1)
      end
    end

    context 'when input incorrect' do
      it 'should render edit template' do
        session[:user_id] = user1.id
        expect(put :update, id: user1.id, user: { username: '', email: user1.email }).to render_template(:edit)
      end

      it 'should not change anything ' do
        session[:user_id] = user1.id
        put :update, id: user1.id, user: { username: '', email: user1.email }
        expect(assigns(:user)).to eq(user1)
      end
    end
  end

  context 'DELETE#destroy' do
    it 'should redirect to users index' do
      session[:user_id] = user1.id
      expect(delete :destroy, id: user1.id).to redirect_to(users_path)
    end

    it 'should decrease count of users if login as deleted user' do
      session[:user_id] = user2.id
      expect { delete :destroy, id: user2.id }.to change { User.count }.by(-1)
    end

    it 'should not decrease count of users unless login as deleted user' do
      session[:user_id] = user1.id
      expect { delete :destroy, id: user2.id }.to change { User.count }.by(0)
    end

    it 'should delete user' do
      session[:user_id] = user3.id
      delete :destroy, id: user3.id
      expect { get :show, id: user3.id }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
