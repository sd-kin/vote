# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let!(:user) { FactoryGirl.create(:user) }

  context 'GET#new' do
    it 'should be success' do
      expect(get :new).to be_success
    end
  end

  context 'POST#create' do
    context 'when input correct' do
      before(:each) { post :create, session: { email: user.email, password: user.password } }

      it 'should redirect to ready polls page' do
        is_expected.to redirect_to ready_polls_path
      end

      it 'should loggin in user' do
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context 'when input incorrect' do
      before(:each) { post :create, session: { email: 'nonexistent', password: 'nevermind' } }

      it 'should render template "new"' do
        is_expected.to render_template :new
      end

      it 'should have error in flash' do
        expect(flash[:error]).to_not be_nil
      end
    end
  end

  context 'DELETE#desteoy' do
    subject { delete :destroy }
    before(:each) { post :create, session: { email: user.email, password: user.password } }

    it 'should redirect to root path' do
      is_expected.to redirect_to(root_path)
    end

    it 'should logout user' do
      subject
      expect(session[:user_id]).to be_nil
    end
  end
end
