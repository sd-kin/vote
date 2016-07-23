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

  context 'PUT#update' do
    context 'when input correct' do
      it 'should redirect to show page' do
        expect(put :update, id: user1.id, user: { username: user1.username, email: user1.email }).to redirect_to(user_path)
      end

      it 'should change only user username' do
        put :update, id: user2.id, user: { username: 'newname', email: user2.email }
        expect(assigns(:user).username).to eq("newname")
      end

      it 'should change user username' do
        put :update, id: user2.id, user: { username: user2.username, email: 'new@mail' }
        expect(assigns(:user).email).to eq("new@mail")
      end

      it 'should not change anything if nothing changed' do
        put :update, id: user1.id, user: { username: user1.username, email: user1.email }
        expect(assigns(:user)).to eq(user1)
      end
    end

    context 'when input incorrect' do
      it 'should render edit template' do
        expect(put :update, id: user1.id, user: { username: '', email: user1.email }).to render_template(:edit)
      end

      it 'should not change anything ' do
        put :update, id: user1.id, user: { username: '', email: user1.email }
        expect(assigns(:user)).to eq(user1)
      end
    end
  end

  context 'DELETE#destroy' do
    it 'should redirect to users index' do
      expect(delete :destroy, id: user1.id).to redirect_to(users_path)
    end

    it 'should decrease count of users' do
      expect { delete :destroy, id: user2.id }.to change { User.count }.by(-1)
    end

    it 'should delete user' do
      delete :destroy, id: user3.id
      expect { get :show, id: user3.id }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
