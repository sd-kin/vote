# frozen_string_literal: true
require 'rails_helper'
include ActionView::RecordIdentifier

RSpec.feature 'Adding images', type: :feature do
  given(:user) { FactoryGirl.create :user }
  given(:poll) { FactoryGirl.create :valid_poll, status: :draft, max_voters: 1, user: user }

  before(:each) { login_as(user) }

  feature 'to user' do
    scenario '- avatar can be added and changed' do
      visit user_path(user)

      expect(page).to have_xpath("//img[contains(@src, '/avatars/missing.png')]")

      click_link   'Edit'
      attach_file  'user_avatar', 'spec/fixtures/files/test_image.png'
      click_button 'Update User'

      expect(page).to_not have_xpath("//img[contains(@src, '/images/no-profile.jpg')]")
      expect(page).to have_xpath("//img[contains(@src, 'medium/test_image.png')]")

      click_link   'Edit'
      attach_file  'user_avatar', 'spec/fixtures/files/test_image2.png'
      click_button 'Update User'

      expect(page).to_not have_xpath("//img[contains(@src, 'medium/test_image.png')]")
      expect(page).to     have_xpath("//img[contains(@src, 'medium/test_image2.png')]")
    end
  end

  feature 'to poll', js: true do
    scenario '- can create poll with image and delete it' do
      visit new_poll_path

      expect(page).to_not have_selector('img')

      fill_in 'poll_title', with: 'new poll'
      select 1.year.from_now.strftime('%Y'), from: 'poll_expire_at_1i'
      attach_file  'poll_images', 'spec/fixtures/files/test_image.png'
      click_button 'Ok'

      expect(page).to have_xpath("//img[contains(@src, 'medium/test_image.png')]")

      click_link 'edit'
      attach_file  'poll_images', 'spec/fixtures/files/test_image2.png'
      click_button 'Ok'

      expect(page).to have_xpath("//img[contains(@src, 'medium/test_image.png')]")
      expect(page).to have_xpath("//img[contains(@src, 'medium/test_image2.png')]")

      click_link 'edit'
      click_link('delete image', match: :first)
      click_button 'Ok'

      expect(page).to have_no_xpath("//img[contains(@src, 'medium/test_image2.png')]")
      expect(page).to have_xpath("//img[contains(@src, 'medium/test_image.png')]")
    end
  end

  feature 'to comment', js: true do
    scenario 'can create comment with image and remove image after' do
      visit poll_path(poll)

      expect(page).to_not have_selector('img')

      fill_in 'comment[body]', with: 'comment text'
      attach_file  'comment[images][]', 'spec/fixtures/files/test_image.png'
      click_button 'Create Comment'

      expect(page).to have_xpath("//img[contains(@src, 'medium/test_image.png')]")

      within '#' + dom_id(poll.comments.last) do
        click_link 'edit'
        click_link('delete image')
        click_button('Update Comment')
      end

      expect(page).to have_no_xpath("//img[contains(@src, 'medium/test_image.png')]")
    end
  end
end
