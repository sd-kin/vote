# frozen_string_literal: true
require 'rails_helper'

RSpec.describe OptionsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:poll) { FactoryGirl.create(:valid_poll, user_id: user.id) }
  let(:option) { poll.options.first }

  describe 'GET #index' do
  end

  describe 'GET #show' do
    context 'when option exist' do
      subject { get :show, xhr: true, params: { poll_id: poll, id: option } }

      it { is_expected.to be_success }

      it 'have correct option' do
        subject
        expect(assigns(:option)).to eq(option)
      end
    end

    context 'when option does not exist' do
    end
  end

  describe 'GET #new' do
  end

  describe 'GET #edit' do
    subject { get :edit, xhr: true, params: { poll_id: poll, id: option } }

    context 'when owner does it' do
      before(:each) { session[:user_id] = user.id }

      it { is_expected.to be_success }
    end

    context 'when not owner does it' do
      before(:each) { session[:user_id] = user.id + 1 }

      it { is_expected.to be_success }

      it 'redirect to root' do
        subject
        expect(response.body).to eq('window.location = "/"')
      end
    end
  end

  describe 'PUT #create' do
    subject { post :create, xhr: true, params: { poll_id: poll, option: FactoryGirl.attributes_for(:valid_option) } }

    context 'when owner does it' do
      before(:each) { session[:user_id] = user.id }

      it { is_expected.to be_success }
    end

    context 'when not owner does it' do
      before(:each) { session[:user_id] = user.id + 1 }

      it { is_expected.to be_success }

      it 'redirect to root' do
        subject
        expect(response.body).to eq('window.location = "/"')
      end
    end
  end

  describe 'PUT #update' do
    subject { put :update, xhr: true, params: { poll_id: poll, id: option, option: FactoryGirl.attributes_for(:valid_option) } }

    context 'when owner does it' do
      before(:each) { session[:user_id] = user.id }

      it { is_expected.to be_success }

      it 'change option title' do
        subject

        expect(assigns(:option).title).to_not eq(option.title)
      end

      it 'change poll status back to draft' do
        option.poll.ready!

        subject

        expect(option.poll.reload).to be_draft
      end
    end

    context 'when not owner does it' do
      before(:each) { session[:user_id] = user.id + 1 }

      it { is_expected.to be_success }

      it 'redirect to root' do
        subject
        expect(response.body).to eq('window.location = "/"')
      end

      it 'not change option title' do
        subject

        expect(assigns(:option).title).to eq(option.title)
      end
    end
  end

  describe 'DESTROY #delete' do
    subject { delete :destroy, xhr: true, params: { id: option, poll_id: poll } }

    context 'when owner does it' do
      before(:each) { session[:user_id] = user.id }

      it { is_expected.to be_success }

      it 'decrease options count' do
        expect { subject }.to change { poll.reload.options.count }.by(-1)
      end

      it 'change poll status back to draft' do
        option.poll.ready!

        subject

        expect(option.poll.reload).to be_draft
      end
    end

    context 'when not owner does it' do
      before(:each) { session[:user_id] = user.id + 1 }

      it { is_expected.to be_success }

      it 'not decrease options count' do
        expect { subject }.to_not change { poll.reload.options.count }
      end
    end
  end
end
