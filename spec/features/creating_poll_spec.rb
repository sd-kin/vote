require 'rails_helper'

feature 'creating poll' do
  scenario 'visit home page' do
    visit root_path

    expect(page).to have_content('Hello world')
  end

  scenario 'visit create poll page' do
    visit new_poll_path

    expect(page).to have_content('New poll page')
  end

  scenario 'create poll', js: true do
    visit new_poll_path
    fill_in 'poll_title', with: 'poll title'
    click_button 'Ok'

    expect(page).to have_content('poll title')
  end

  scenario 'create poll with two options', js: true  do
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

  scenario 'can not create poll without title' do
    visit new_poll_path
    click_button 'OK'

    expect(page).to have_content("Title can't be blank")
  end

  scenario 'can not create poll without option title' do
    visit new_poll_path
    fill_in 'poll_title', with: 'poll title'
    fill_in 'Description', with: 'option description'
    click_button 'OK'

    expect(page).to have_content("Options can't be blank")
  end

  scenario 'can not create poll without description' do
    visit new_poll_path
    fill_in 'poll_title', with: 'poll title'
    fill_in 'poll_options_attributes_0_title', with: 'option title'
    click_button 'OK'

    expect(page).to have_content("Options can't be blank")
  end
end
