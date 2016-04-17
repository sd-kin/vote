feature 'creating poll' do
  scenario 'visit home page' do
    visit root_path

    expect(page).to have_content('Hello world')
  end

  scenario 'visit create poll page' do
    visit new_poll_path

    expect(page).to have_content('New poll page')
  end

  scenario 'create poll' do
    visit new_poll_path
    fill_in 'poll_title', with: 'poll title'
    click_button 'Ok'

    expect(page).to have_content('poll title')
  end

  scenario 'create poll with two options' do
    visit new_poll_path
    click_button 'Add option'
    fill_in 'poll_title', with: 'poll title'
    fill_in 'poll_options_attributes_0_title', with: 'option 1 title'
    fill_in 'poll_options_attributes_0_description', with: 'option 1 description'
    fill_in 'poll_options_attributes_1_title', with: 'option 2 title'
    fill_in 'poll_options_attributes_1_description', with: 'option 2 description'
    click_button 'OK'

    expect(page).to have_content('This is poll index page')
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
