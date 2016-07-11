# frozen_string_literal: true
require 'rails_helper'

feature 'when build a new user' do
  before(:each) { visit new_user_path }

  scenario 'should have field for username' do
    expect(page).to have_field('user_username')
  end

  scenario 'should have field for email' do
    expect(page).to have_field('user_email')
  end
end

feature 'when create user' do
  context 'and input incorrect' do
    scenario 'should render error without username' do
      visit new_user_path
      fill_in 'user_email', with: 'test@test'
      click_button 'Create User'
      expect(page).to have_content('Username can\'t be blank')
    end

    scenario 'should render error without email' do
      visit new_user_path
      fill_in 'user_username', with: 'test'
      click_button 'Create User'
      expect(page).to have_content('Email can\'t be blank')
    end
  end
end
