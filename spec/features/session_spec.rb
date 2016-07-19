# frozen_string_literal: true
require 'rails_helper'

feature 'when open log in page' do
  scenario 'should see login form' do
    visit new_session_path
    expect(page).to have_field('session_email')
    expect(page).to have_field('session_password')
  end
end

feature 'when try to log in' do
  context 'and input incorrect' do
    it 'should render error message' do
      visit new_session_path
      fill_in 'session_email', with: 'test@test.test'
      fill_in 'session_password', with: '1234567890'
      click_button 'Log in'

      expect(page).to have_css('#log_in_error')
    end
  end
end
