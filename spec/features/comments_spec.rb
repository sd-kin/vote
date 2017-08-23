# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Commenting', type: :feature do
  given(:user) { FactoryGirl.create :user }
  given(:poll) { FactoryGirl.create :valid_poll, :with_comments, user_id: user.id }

  before(:each) { login_as(user) }

  feature 'when Add comment to poll' do
    scenario 'have field for new comment' do
      visit poll_path(poll)

      expect(page).to have_field('comment[body]')
    end

    scenario 'Add comment', js: true do
      create_comment('test comment text')

      expect(page).to have_content('test comment text')
    end
  end

  feature 'when Add comment to another comment', js: true do
    scenario 'comment have form for reply' do
      visit poll_path(poll)

      within "#comment_#{poll.comments.first.id}" do
        expect(page).to have_link('Reply')
        expect(page).to have_no_field('comment[body]')

        click_link 'Reply'

        expect(page).to have_no_link('Reply')
        expect(page).to have_field('comment[body]')
      end
    end

    scenario 'Add comment' do
      visit poll_path(poll)

      within "#comment_#{poll.comments.first.id}" do
        click_link 'Reply'
        fill_in 'comment[body]', with: 'test comments comment text'
        click_button 'Add comment'
      end

      expect(page).to have_content('test comments comment text')
    end
  end

  feature 'when user own comment', js: true do
    scenario 'can modify comment text' do
      create_comment 'new comment text'
      expect(page).to have_content 'new comment text'

      within("#comment_#{poll.comments.where(body: 'new comment text').first.id}") do
        expect(page).to have_link 'edit'
        click_link 'edit'

        expect(page).to have_field('comment[body]')
        fill_in 'comment[body]', with: 'edited comment text'
        click_button 'Add comment'

        expect(page).to have_no_content 'new comment text'
        expect(page).to have_content 'edited comment text'
      end
    end

    scenario 'can delete comment' do
      create_comment 'new comment text'
      expect(page).to have_content 'new comment text'

      within("#comment_#{poll.comments.where(body: 'new comment text').first.id}") do
        expect(page).to have_link 'delete'
        click_link 'delete'
      end

      expect(page).to have_no_content 'new comment text'
    end
  end

  feature 'when user does not own comment', js: true do
    scenario 'can not edit or delete comment' do
      visit poll_path(poll)

      within("#comment_#{poll.comments.first.id}") do
        expect(page).to have_no_link 'edit'
        expect(page).to have_no_link 'delete'
      end
    end
  end
end

def create_comment(comment_text)
  visit poll_path(poll)
  fill_in 'comment[body]', with: comment_text
  click_button 'Add comment'
end
