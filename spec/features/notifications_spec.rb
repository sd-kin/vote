# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Commenting', pending: "Notifications disabled", type: :feature do
  given(:user)  { FactoryGirl.create :user }
  given(:user2) { FactoryGirl.create :user }
  given(:poll)  { FactoryGirl.create :valid_poll, status: :ready, max_voters: 1, user: user }

  feature 'when poll finished', js: true do
    scenario 'notify author and voters' do
      login_as(user2)
      visit poll_path(poll)
      click_button 'make choice'
      visit poll_path(poll)
      click_link 'Notifications'

      expect(page).to have_content('Poll, your voted for, was closed.')

      click_link 'Logout'
      login_as(user)
      click_link 'Notifications'

      expect(page).to have_content('Your poll was finished.')
    end
  end

  feature 'when poll commented', js: true do
    scenario 'notify poll author' do
      login_as(user2)
      visit poll_path(poll)
      fill_in 'comment[body]', with: 'new comment to poll'
      click_button 'Add comment'
      click_link 'Logout'
      login_as(user)
      click_link 'Notifications'

      expect(page).to have_content('You have new reply.')
    end
  end

  feature 'when comment commented', js: true do
    scenario 'notify comment author' do
      login_as(user2)
      visit poll_path(poll)
      fill_in 'comment[body]', with: 'new comment to poll'
      click_button 'Add comment'

      click_link 'Logout'
      login_as(user)
      visit poll_path(poll)

      within "#comment_#{poll.comments.first.id}" do
        click_link 'Reply'
        fill_in 'comment[body]', with: 'new comment to comment'
        click_button 'Add comment'
      end

      click_link 'Logout'
      login_as(user2)
      click_link 'Notifications'

      expect(page).to have_content('You have new reply.')
    end
  end
end
