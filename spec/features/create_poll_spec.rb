# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Create poll', type: :feature do
  describe 'filling create form', js: true do
    context 'when all fields correct' do
      let(:title)            { 'New Shiny Poll' }
      let(:voters_limit)     { '1234' }
      let(:expiration_date)  { (1.year.from_now + 1.day).strftime('%Y/%m/%d %H:%m') }
      let(:poll_description) { "Poll status is draft. Voters count limited up to #{voters_limit}. Votation process will be stopped in about 1 year" }
      let(:options) do
        {
          first:  { title: '1st', description: 'first option' },
          second: { title: '2nd', description: 'second option' },
          third:  { title: '3rd', description: 'third option' },
          fourth: { title: '4th', description: 'fourth option' }
        }
      end

      it 'create poll' do
        visit new_poll_path

        # has inputs for 3 options
        expect(page).to have_css '.option-fields-group', count: 3

        click_button 'Create poll'

        expect(page).to have_content('Title can\'t be blank')
        expect(page).to have_content('Poll should have at least 3 options')

        fill_in 'Title', with: title

        click_button 'Change voters limit'
        fill_in 'poll[max_voters]', with: voters_limit

        click_button 'Change expiration date'
        fill_in 'poll[expire_at]', with: expiration_date

        attach_file 'image_input', 'spec/fixtures/files/test_image.png', visible: false

        within '#options-form' do
          click_button 'Add option'

          # adds one more input group for option
          expect(page).to have_css '.option-fields-group', count: 4
        end

        # fill in fields for first option
        within '#options-form .option-fields-group:nth-child(2)' do
          fill_in 'new_options[][title]',       with: options[:first][:title]
          fill_in 'new_options[][description]', with: options[:first][:description]
        end

        # fill in fields for second option
        within '#options-form .option-fields-group:nth-child(3)' do
          fill_in 'new_options[][title]',       with: options[:second][:title]
          fill_in 'new_options[][description]', with: options[:second][:description]
        end

        # fill in fields for third option
        within '#options-form .option-fields-group:nth-child(4)' do
          fill_in 'new_options[][title]',       with: options[:third][:title]
          fill_in 'new_options[][description]', with: options[:third][:description]
        end

        # fill in fields for fourth option
        within '#options-form .option-fields-group:nth-child(5)' do
          fill_in 'new_options[][title]',       with: options[:fourth][:title]
          fill_in 'new_options[][description]', with: options[:fourth][:description]
        end

        click_button 'Create poll'

        expect(page).to have_content('New Shiny Poll')

        expect(page).to have_content(options[:first][:title])
        expect(page).to have_content(options[:second][:title])
        expect(page).to have_content(options[:third][:title])
        expect(page).to have_content(options[:fourth][:title])

        expect(page).to have_content(poll_description)
        expect(page).to have_xpath("//img[contains(@src, 'medium/test_image.png')]")
      end
    end
  end
end
