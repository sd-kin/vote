# frozen_string_literal: true
require 'rails_helper'

# test reopening browser simulation
feature 'when reopen browser' do
  context 'and user was logged in' do
    before(:each) do
      user = FactoryGirl.create(:user)
      visit root_path
      click_link 'Login'
      fill_in 'session_email', with: user.email
      fill_in 'session_password', with: user.password
      check 'session_remember_me'
      click_button 'Login'
    end

    scenario 'should stay logged in' do
      expect(page).to have_link('Logout')

      expire_cookies
      visit root_path

      expect(page).to have_content('Logout')
    end

    scenario 'should resist cookie hijacking' do
      saved_cookie = get_cookie('user_id').first
      click_link 'Logout'
      expire_cookies
      cookies << saved_cookie
      visit root_path

      expect(page).to have_link('Login')
    end
  end
end

feature 'when open Login page' do
  scenario 'should see Logout form' do
    visit login_path
    expect(page).to have_field('session_email')
    expect(page).to have_field('session_password')
  end
end

feature 'when try to Login' do
  context 'and input incorrect' do
    scenario 'should render error message' do
      visit login_path
      fill_in 'session_email', with: 'test@test.test'
      fill_in 'session_password', with: '1234567890'
      click_button 'Login'

      expect(page).to have_css('#flash_messages')
    end
  end
end

feature 'after successful Logout' do
  before(:each) do
    user = FactoryGirl.create(:user)
    visit root_path
    click_link 'Login'
    fill_in 'session_email', with: user.email
    fill_in 'session_password', with: user.password
    click_button 'Login'
  end

  scenario 'link to Logout changes to link to logout' do
    expect(page).to have_no_link('Login')
    expect(page).to have_link('Logout')
  end

  scenario 'link to logout changes to link to Logout' do
    click_link 'Logout'
    expect(page).to have_link('Login')
    expect(page).to have_no_link('Logout')
  end
end

feature 'remember me function' do
  scenario 'should have check-box on Logout page' do
    visit login_path

    expect(page).to have_css('input[type=checkbox]#session_remember_me')
  end

  context 'if check-box checked' do
    it 'should remember user' do
      user = FactoryGirl.create(:user)
      visit root_path
      click_link 'Login'
      fill_in 'session_email', with: user.email
      fill_in 'session_password', with: user.password
      check 'session_remember_me'
      click_button 'Login'

      expire_cookies

      visit root_path

      expect(page).to have_link('Logout')
    end
  end

  context 'if check-box not checked' do
    it 'should not remember user' do
      user = FactoryGirl.create(:user)
      visit root_path
      click_link 'Login'
      fill_in 'session_email', with: user.email
      fill_in 'session_password', with: user.password
      uncheck 'session_remember_me'
      click_button 'Login'

      expire_cookies

      visit root_path

      expect(page).to have_link('Login')
    end
  end
end
