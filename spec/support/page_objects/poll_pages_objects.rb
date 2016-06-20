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

    def create_poll(title: 'poll title')
      fill_in 'poll_title', with: title
      click_button 'Ok'
    end

    def correct_page?
      has_content?('New poll page')
    end

    def title
      find(:xpath, '//div[contains (@id, "title_for_poll")]').text.gsub('Title: ', '')
    end

    def has_form_for_title?
      has_content?('Title')
    end

    def has_validation_error?
      has_content?("can't be blank")
    end
  end

  class EditPollPage < Page
    def visit_page(title: 'poll title')
      visit new_poll_path
      fill_in 'poll_title', with: title
      click_button 'Ok'

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

    def title
      find(:xpath, '//div[contains (@id, "title_for_poll")]').text.gsub('Title: ', '')
    end
  end

  class ShowPollPage < Page
    def visit_page(title: 'poll title')
      current_page = EditPollPage.new
      current_page.visit_page(title: title)
      current_page.create_option
      visit poll_path(id: 1)
      self
    end

    def title
      find(:xpath, '//div[contains (@id, "title_for_poll")]').text.gsub('Title: ', '')
    end

    def vote
      click_button('make choice')
    end

    def has_accepted_message?
      has_content?('choice accepted')
    end

    def has_already_accepted_message?
      has_content?('already accepted')
    end

    def has_button_for_vote?
      has_button?('make choice')
    end
  end
end
