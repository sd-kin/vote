# frozen_string_literal: true
require 'rails_helper'
require 'support/page_objects/poll_pages_objects'

include PollPagesObjects

feature 'when create poll' do
  scenario 'should visit home page' do
    current_page = RootPage.new
    current_page.visit_page

    expect(current_page).to be_correct_page
  end

  scenario 'should visit create poll page' do
    current_page = NewPollPage.new
    current_page.visit_page

    expect(current_page).to be_correct_page
  end

  scenario 'should render form for title' do
    current_page = NewPollPage.new
    current_page.visit_page

    expect(current_page).to have_form_for_title
  end

  scenario 'should create poll with title', js: true do
    current_page = NewPollPage.new
    current_page.visit_page
    current_page.create_poll(title: 'new poll title')
    wait_for_ajax

    expect(current_page.title).to eq('new poll title')
  end

  scenario 'should not create poll without title', js: true do
    current_page = NewPollPage.new
    current_page.visit_page
    current_page.create_poll(title: '')
    wait_for_ajax

    expect(current_page).to have_validation_error
  end
end

feature 'when create options for poll', js: true do
  scenario 'should render form for new option' do
    current_page = EditPollPage.new
    current_page.visit_page
    wait_for_ajax

    expect(current_page).to have_form_for_option
  end

  scenario 'should create poll with two options', js: true do
    current_page = EditPollPage.new
    current_page.visit_page
    current_page.create_option(title = 'option 1 title', description = 'option 1 description')
    wait_for_ajax

    expect(current_page).to have_content('option 1 title')
    expect(current_page).to have_content('option 1 description')

    current_page.create_option(title = 'option 2 title', description = 'option 2 description')
    wait_for_ajax

    expect(current_page).to have_content('option 2 title')
    expect(current_page).to have_content('option 2 description')
  end

  scenario 'should not create poll without option title' do
    current_page = EditPollPage.new
    current_page.visit_page
    current_page.create_option(title = '', description = 'option 1 description')
    wait_for_ajax

    expect(current_page).to have_validation_error
  end

  scenario 'should not create poll without description' do
    current_page = EditPollPage.new
    current_page.visit_page
    current_page.create_option(title = 'option 1 title', description = '')
    wait_for_ajax

    expect(current_page).to have_validation_error
  end
end

feature 'after create poll' do
  scenario 'should be accessible by index page', js: true do
    current_page = NewPollPage.new
    current_page.visit_page
    current_page.create_poll(title: 'test title')
    wait_for_ajax
    current_page = IndexPollsPage.new
    current_page.visit_page
    click_link('test title')

    expect(current_page.title).to eq('test title')
  end
end

feature 'when changing poll status' do
  scenario 'poll without options cant be ready', js: true do
    current_page = EditPollPage.new
    current_page.visit_page
    current_page.make_ready
    wait_for_ajax

    expect(current_page).to have_status_validation_error
  end

  scenario 'new poll has default status(draft)', js: true do
    current_page = EditPollPage.new
    current_page.visit_page
    wait_for_ajax

    expect(current_page).to have_status
  end

  scenario 'poll with options can be ready', js: true do
    current_page = EditPollPage.new
    current_page.visit_page
    current_page.create_option
    wait_for_ajax
    current_page.make_ready
    wait_for_ajax

    expect(current_page).to have_status('ready')
  end

  scenario 'ready poll return to draft when all options deleted', js: true do
    current_page = EditPollPage.new
    current_page.visit_page
    current_page.create_option
    current_page.make_ready
    current_page.destroy_option
    wait_for_ajax

    expect(current_page).to have_status
  end
end

feature 'when cast a vote' do
  given(:poll) { FactoryGirl.create(:valid_poll, status: :ready) }

  scenario 'can access vote by unique URL', js: true do
    current_page = ShowPollPage.new
    current_page.visit_page

    expect(current_page.title).to eq('poll title')
  end

  scenario 'can cast a vote and see that his choice accepted, but only once', js: true do
    visit poll_path(id: poll.id)

    expect(page).to have_button('make choice')
    expect(page).to have_no_link('see results')

    click_button('make choice')

    expect(page).to have_content('choice has been accepted')
    expect(page).to have_link('see results')
    expect(page).to have_no_button('make choice')

    visit poll_path(id: poll.id)

    expect(page).to have_content('choice has been accepted')
    expect(page).to have_link('see results')
    expect(page).to have_no_button('make choice')
  end
end

feature 'when want to see poll result' do
  given(:poll) { FactoryGirl.create(:valid_poll, status: :ready) }

  scenario 'cant do it before vote' do
    visit result_poll_path(id: poll.id)
    expect(page).to have_content('You can see results after you make your choice.')
  end

  scenario 'after voted current poll', js: true do
    visit poll_path(id: poll.id)
    click_button('make choice')
    click_link('see results')

    expect(page).to have_content('weight is')
  end
end
