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
  scenario 'should create poll with two options' do
    visit new_poll_path
    fill_in 'poll_title', with: 'poll title'
    click_button 'Ok'
    fill_in 'option_title', with: 'option 1 title'
    fill_in 'option_description', with: 'option 1 description'
    click_button 'Add'
    fill_in 'option_title', with: 'option 2 title'
    fill_in 'option_description', with: 'option 2 description'
    click_button 'Add'
    wait_for_ajax

    expect(page).to have_content('option 1 title')
    expect(page).to have_content('option 2 title')
    expect(page).to have_content('option 1 description')
    expect(page).to have_content('option 2 description')
  end

  scenario 'should not create poll without option title' do
    visit new_poll_path
    fill_in 'poll_title', with: 'poll title'
    click_button 'Ok'
    fill_in 'option_description', with: 'option 1 description'
    click_button 'Add'

    expect(page).to have_content("Title can't be blank")
  end

  scenario 'can not create poll without description' do
    visit new_poll_path
    fill_in 'poll_title', with: 'poll title'
    click_button 'Ok'
    fill_in 'option_title', with: 'option 1 title'
    click_button 'Add'

    expect(page).to have_content("Description can't be blank")
  end
end
