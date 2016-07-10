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
