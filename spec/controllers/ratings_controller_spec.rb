# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  let!(:user) { FactoryGirl.create(:user) }
  let(:logged_in_user) { FactoryGirl.create(:user) }
  before(:each) { session[:user_id] = logged_in_user }

  context 'POST#increase' do
    it 'increase rating' do
      expect { post :increase, xhr: true, params: { id: user.rating } }.to change { user.reload.rating.value }.by(1)
    end
  end

  context 'POST#decrease' do
    it 'decrease rating' do
      expect { post :decrease, xhr: true, params: { id: user.rating } }.to change { user.reload.rating.value }.by(-1)
    end
  end
end
