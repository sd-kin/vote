# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreplay@vote.test'
  layout 'mailer'
end
