# frozen_string_literal: true
module ExpireCookies
  def expire_cookies
    cookies.reject! do |existing_cookie|
      # See http://jamesferg.com/testing/bdd/hacking-capybara-cookies/
      # catch session cookies/no expiry (nil) and past expiry (true)
      existing_cookie.expired? != false
    end
  end

  def get_cookie(name)
    cookies.select { |c| c.name == name }
  end

  private

  def cookies
    cookiejar.instance_variable_get(:@cookies)
  end

  def cookiejar
    Capybara.current_session.driver.browser.current_session.instance_variable_get(:@rack_mock_session).cookie_jar
  end
end
