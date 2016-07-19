# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  context 'GET#new' do
    it 'should be success' do
      expect(get :new).to be_success
    end
  end

  context 'POST#create' do
    context 'when input correct' do
      let!(:user) { FactoryGirl.create(:user) }
      subject { post :create, session: { email: user.email, password: user.password } }

      it 'should redirect to ready polls page' do
        is_expected.to redirect_to ready_polls_path
      end

      it 'should loggin in user' do
        subject
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context 'when input incorrect' do
      subject { post :create, session: { email: 'nonexistent', password: 'nevermind' } }

      it 'should render template "new"' do
        expect(subject).to render_template :new
      end

      it 'should have error in flash' do
        subject
        expect(flash[:error]).to_not be_nil
      end
    end
  end
end
