# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Update poll', type: :feature do
  let(:author) { FactoryGirl.create :user }
  let(:poll) { FactoryGirl.create :valid_poll, user: author }

  before(:each) { login_as(author) }

  feature 'update title', js: true do
    it 'changes' do
      visit edit_poll_path(poll)

      fill_in 'poll[title]', with: 'new poll title'

      click_button 'Update poll'

      expect(page).to have_content('new poll title')
    end
  end

  feature 'change status', js: true do
    it 'changes from draft to ready' do
      visit edit_poll_path(poll)

      find('label', text: 'Make ready').click

      expect(page).to have_css('label', text: 'Return to draft')

      click_button 'Update poll'

      expect(page).to have_content('status is ready')
    end
  end
end
