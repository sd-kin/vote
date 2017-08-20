require 'rails_helper'

RSpec.feature 'babel', type: :feature do
  it 'compile js to es2015', js: true do
    visit root_path

    expect(page).to have_content('hello from es6')
    expect(page).to have_content('hello from 2015')
  end
end