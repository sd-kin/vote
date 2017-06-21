# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Services::Users::Registration do
  it 'redirect .call to #call' do
    expect_any_instance_of(Services::Users::Registration).to receive(:call).with(1, 2, 3)
    Services::Users::Registration.call(1, 2, 3)
  end
end
