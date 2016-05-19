# encoding: utf-8
# frozen_string_literal: true
module PollPagesObjects
  class Page
    include Capybara::DSL
    include Rails.application.routes.url_helpers

    default_url_options[:host] = ::Rails.application.routes.default_url_options[:host] || 'localhost'
  end

  class RootPage < Page
    def visit_page
      visit root_path
      self
    end

    def correct_page?
      has_content?('Hello world')
    end
  end

  class NewPollPage < Page
    def visit_page
      visit new_poll_path
      self
    end

    def create_poll(title = 'poll title')
      fill_in 'poll_title', with: title
      click_button 'Ok'
    end

    def correct_page?
      has_content?('New poll page')
    end

    def has_correct_title?(title = 'poll title')
      has_content?(title)
    end

    def has_form_for_title?
      has_content?('Title')
    end

    def has_validation_error?
      has_content?("can't be blank")
    end
  end

  class EditPollPage < Page
    def visit_page
      NewPollPage.new.visit_page.create_poll
      self
    end

    def create_option(title = 'title', description = 'description')
      fill_in 'option_title', with: title
      fill_in 'option_description', with: description
      click_button 'Add'
    end

    def destroy_option
      find('a', text: 'Delete').click
    end

    def make_ready
      click_button 'Make ready'
    end

    def has_form_for_option?
      has_content?('Title') && has_content?('Description')
    end

    def has_validation_error?
      has_content?("can't be blank")
    end

    def has_status_validation_error?
      has_content?("Status can't be")
    end

    def has_status?(status = 'draft')
      has_content?(status)
    end
  end

  class IndexPollsPage < Page
    def visit_page
      visit polls_path
      self
    end

    def has_expected_title?(title = 'poll title')
      has_content?(title)
    end
  end
end
