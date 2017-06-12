# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:anonimous_user) { User.create_anonimous! }

  context 'GET#index' do
    subject { get :index }

    it { is_expected.to be_success }

    it 'get all named users' do
      subject
      expect(assigns(:users)).to match_array([user, user2])
    end
  end

  context 'GET#new' do
    subject { get :new }

    it { is_expected.to be_success }

    it 'build new user' do
      subject
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  context 'POST#create' do
    subject { post :create, params: { user: user_params } }

    context 'when anonimous user exists' do
      let(:user_params) { FactoryGirl.attributes_for(:user) }
      before(:each) { session[:user_id] = anonimous_user.id }

      it 'not create user' do
        expect { subject }.to_not change { User.count }
      end

      it 'not change user id' do
        subject
        expect(assigns(:user).id).to eq(anonimous_user.id)
      end
    end

    context 'when anonimous user does not exists' do
      context 'and correct params' do
        let(:user_params) { FactoryGirl.attributes_for(:user) }

        it { is_expected.to redirect_to(ready_polls_path) }

        it 'log in user' do
          subject

          expect(session[:user_id]).to eq(assigns(:user).id)
        end

        it 'increase users count' do
          expect { subject }.to change { User.count }.by(1)
        end
      end

      context 'and not correct params' do
        let(:user_params) { FactoryGirl.attributes_for(:user, email: '') }

        it { is_expected.to render_template(:new) }

        it 'create anonimous user' do
          subject
          expect(assigns(:user).reload).to be_anonimous
        end
      end
    end
  end

  context 'GET#edit' do
    subject { get :edit, params: { id: user.id } }

    context 'when user logged in' do
      context 'and try to edit own profile' do
        before(:each) { session[:user_id] = user.id }

        it { is_expected.to be_success }

        it { is_expected.to render_template :edit }

        it 'not build new user' do
          subject

          expect(assigns(:user)).not_to be_a_new(User)
        end
      end

      context 'and try to edit another user profile' do
        before(:each) { session[:user_id] = user2.id }

        it { is_expected.to redirect_to edit_user_path(user2) }
      end
    end

    context 'when user not logged in' do
      # edit anonimous user profile in order to registering it without loosing user activites
      it { is_expected.to redirect_to edit_user_path(session[:user_id]) }
    end
  end

  context 'GET#show' do
    subject { get :show, params: { id: user.id } }

    it { is_expected.to be_success }

    it 'get correct user' do
      subject
      expect(assigns(:user)).to eq(user)
    end
  end

  context 'PUT#update' do
    subject { put :update, params: { id: user.id, user: user_params } }

    context 'when user logged in' do
      context 'and update own parameters' do
        before(:each) { session[:user_id] = user.id }

        context 'and correct params' do
          let(:user_params) { FactoryGirl.attributes_for(:user) }

          it { is_expected.to redirect_to user_path }

          it 'change user info' do
            subject

            expect(assigns(:user).username).to eq(user_params[:username])
            expect(assigns(:user).email).to eq(user_params[:email])
          end
        end

        context 'and incorrect params' do
          let(:user_params) { FactoryGirl.attributes_for(:user, email: '') }

          it { is_expected.to render_template :edit }

          it 'not change anuthing' do
            subject

            expect(assigns(:user)).to eq(user)
          end
        end
      end

      context 'and update another user parameters' do
        before(:each) { session[:user_id] = user2.id }
        let(:user_params) { FactoryGirl.attributes_for(:user) }

        it { is_expected.to render_template :edit }

        it 'not change user info' do
          subject

          expect(assigns(:user)).to eq(user)
        end
      end
    end

    context 'when user not logged in' do
      let(:user_params) { FactoryGirl.attributes_for(:user) }
      # unonimous user can update himself
      it { is_expected.to be_success }
    end
  end

  context 'DELETE#destroy' do
    subject { delete :destroy, params: { id: user.id } }

    context 'when logged in as deleted user' do
      before(:each) { session[:user_id] = user.id }

      it { is_expected.to redirect_to users_path }

      it 'decrease users count' do
        expect { subject }.to change { User.count }.by(-1)
      end
    end

    context 'when not logged in as deleted user' do
      before(:each) { session[:user_id] = user.id + 1 }

      it { is_expected.to render_template :show }

      it 'not change users count' do
        expect { subject }.to_not change { User.count }
      end
    end

    it 'simulate deleting error' do
      user = FactoryGirl.create(:user)
      session[:user_id] = user.id

      expect(user).to receive(:destroy).and_return(false)
      expect(User).to receive(:find).and_return(user)
      expect(delete :destroy, params: { id: user.id }).to render_template(:show)
    end
  end
end
