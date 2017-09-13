# frozen_string_literal: true

require 'rails_helper'
include ActionView::Helpers::DateHelper

RSpec.feature 'Update poll', type: :feature, js: true do
  let(:author)              { FactoryGirl.create :user }
  let(:poll)                { FactoryGirl.create :valid_poll, user: author }
  let(:new_voters_limit)    { 123 }
  let(:new_expiration_date) { 1.year.from_now + 1.day }

  before(:each) { login_as(author) }

  scenario 'can update title' do
    visit edit_poll_path(poll)

    fill_in 'poll[title]', with: 'new poll title'

    click_button 'Update poll'

    expect(page).to have_content('new poll title')
  end

  scenario 'can change status from draft to ready' do
    visit edit_poll_path(poll)

    find('label', text: 'Make ready').click

    expect(page).to have_css('label', text: 'Return to draft')

    click_button 'Update poll'

    expect(page).to have_content('status is ready')
  end

  scenario 'change voters limit' do
    visit edit_poll_path(poll)

    click_button 'Change voters limit'
    fill_in 'poll[max_voters]', with: new_voters_limit

    click_button 'Update poll'

    expect(page).to have_content("limited up to #{new_voters_limit}")
  end

  scenario 'change expiration date' do
    visit edit_poll_path(poll)

    within('#expiration-date') do
      click_button 'Change expiration date'
      expect(page).to have_field('poll[expire_at]', with: poll.expire_at)
    end

    fill_in 'poll[expire_at]', with: new_expiration_date

    click_button 'Update poll'

    expect(page).to have_content("will be stopped in #{distance_of_time_in_words(Time.current, new_expiration_date)}")
  end

  feature 'images' do
    let!(:poll_with_image) { FactoryGirl.create :valid_poll, :with_image, user: author }

    scenario 'can be added' do
      visit edit_poll_path(poll)

      attach_file 'image_input', 'spec/fixtures/files/test_image.png', visible: false
      click_button 'Update poll'

      expect(page).to have_xpath("//img[contains(@src, 'medium/test_image.png')]")
    end

    scenario 'can be deleted' do
      visit edit_poll_path(poll_with_image)

      expect(page).to have_xpath("//img[contains(@src, 'medium/test_image.png')]")
      check("delete_checkbox_for_image_#{poll_with_image.images.first.id}")
      click_button 'Update poll'

      expect(page).to have_no_xpath("//img[contains(@src, 'medium/test_image.png')]")
    end
  end

  feature 'options' do
  end
end
