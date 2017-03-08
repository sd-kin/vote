# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Adding images', type: :feature do
  given(:user) { FactoryGirl.create :user }
  given(:poll) { FactoryGirl.create :valid_poll, status: :draft, max_voters: 1, user: user }

  before(:each) { login_as(user) }

  feature 'user avatar' do
    scenario 'user can add and change avatar' do
      visit user_path(user)

      expect(page).to have_xpath("//img[contains(@src, '/images/no-profile.jpg')]")

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

  feature 'poll image', js: true do
    scenario 'user can create poll with image and delete it' do
      visit new_poll_path

      expect(page).to_not have_selector('img')

      fill_in 'poll_title', with: 'new poll'
      select 1.year.from_now.strftime('%Y'), from: 'poll_expire_at_1i'
      attach_file  'poll_images', 'spec/fixtures/files/test_image.png'
      click_button 'Ok'

      expect(page).to have_xpath("//img[contains(@src, 'medium/test_image.png')]")

      click_link 'edit'
      find_link('delete').click

      expect(page).to_not have_xpath("//img[contains(@src, 'medium/test_image.png')]")
    end

    scenario 'user can add image to existing poll' do
    end
  end

  feature 'comment image' do
  end
end
