# frozen_string_literal: true

module SessionHelpers
  def login_as(user)
    visit root_path
    click_link 'Login'
    fill_in 'session_email', with: user.email
    fill_in 'session_password', with: user.password
    click_button 'Login'
  end
end
