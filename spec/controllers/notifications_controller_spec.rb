# frozen_string_literal: true
require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  let(:user)  { FactoryGirl.create :user, :with_notifications }
  let(:user2) { FactoryGirl.create :user, :with_notifications }

  describe 'GET #index' do
    subject { get :index }

    context 'when user not logged in' do
      it { is_expected.to be_redirect }

      it 'do not set notifications variable' do
        subject
        expect(assigns(:notifications_hash)).to be_nil
      end
    end

    context 'when user logged in' do
      before(:each) { session[:user_id] = user.id }

      it { is_expected.to be_success }

      it 'should have user notifications' do
        subject
        expect(assigns(:notifications)).to match_array(user.notifications)
      end

      it 'do not get all notifications' do
        user2.notifications.create
        subject
        expect(assigns(:notifications)).to_not match_array(Notification.all)
      end
    end
  end
end
