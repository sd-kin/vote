# frozen_string_literal: true
require 'rails_helper'

# test reopening browser simulation
feature 'when reopen browser' do
  context 'and user was logged in' do
    before(:each) do
      user = FactoryGirl.create(:user)
      visit root_path
      click_link 'log in'
      fill_in 'session_email', with: user.email
      fill_in 'session_password', with: user.password
      check 'session_remember_me'
      click_button 'Log in'
    end

    scenario 'should stay logged in' do
      expect(page).to have_link('log out')

      expire_cookies
      visit root_path

      expect(page).to have_content('log out')
    end

    scenario 'should resist cookie hijacking' do
      saved_cookie = get_cookie('user_id').first
      click_link 'log out'
      expire_cookies
      cookies << saved_cookie
      visit root_path

      expect(page).to have_link('log in')
    end
  end
end

feature 'when open log in page' do
  scenario 'should see login form' do
    visit login_path
    expect(page).to have_field('session_email')
    expect(page).to have_field('session_password')
  end
end

feature 'when try to log in' do
  context 'and input incorrect' do
    scenario 'should render error message' do
      visit login_path
      fill_in 'session_email', with: 'test@test.test'
      fill_in 'session_password', with: '1234567890'
      click_button 'Log in'

      expect(page).to have_css('#flash_messages')
    end
  end
end

feature 'after successful login' do
  before(:each) do
    user = FactoryGirl.create(:user)
    visit root_path
    click_link 'log in'
    fill_in 'session_email', with: user.email
    fill_in 'session_password', with: user.password
    click_button 'Log in'
  end

  scenario 'link to login changes to link to logout' do
    expect(page).to have_no_link('log in')
    expect(page).to have_link('log out')
  end

  scenario 'link to logout changes to link to login' do
    click_link 'log out'
    expect(page).to have_link('log in')
    expect(page).to have_no_link('log out')
  end
end

feature 'remember me function' do
  scenario 'should have check-box on login page' do
    visit login_path

    expect(page).to have_css('input[type=checkbox]#session_remember_me')
  end

  context 'if check-box checked' do
    it 'should remember user' do
      user = FactoryGirl.create(:user)
      visit root_path
      click_link 'log in'
      fill_in 'session_email', with: user.email
      fill_in 'session_password', with: user.password
      check 'session_remember_me'
      click_button 'Log in'

      expire_cookies

      visit root_path

      expect(page).to have_link('log out')
    end
  end

  context 'if check-box not checked' do
    it 'should not remember user' do
      user = FactoryGirl.create(:user)
      visit root_path
      click_link 'log in'
      fill_in 'session_email', with: user.email
      fill_in 'session_password', with: user.password
      click_button 'Log in'

      expire_cookies

      visit root_path

      expect(page).to have_link('log in')
    end
  end
end
