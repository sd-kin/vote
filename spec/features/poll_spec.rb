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
    current_page.create_poll

    expect(current_page).to have_correct_title
  end

  scenario 'should not create poll without title', js: true do
    current_page = NewPollPage.new
    current_page.visit_page
    current_page.create_poll('')

    expect(current_page).to have_validation_error
  end
end

feature 'when create options for poll', js: true do 
  scenario 'should render form for new option' do 
    current_page = EditPollPage.new
    current_page.visit_page

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

  scenario 'can not create poll without description' do
    current_page = EditPollPage.new
    current_page.visit_page
    current_page.create_option(title = 'option 1 title', description = '')
    wait_for_ajax

    expect(current_page).to have_validation_error
  end
end

feature 'after create poll' do
  scenario 'should be accesible by index page', js: true do
    current_page = IndexPollPage.new
    current_page.visit_page

    expect(current_page).to have_expected_title
  end
end
