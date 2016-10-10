# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { FactoryGirl.create :comment }

  it 'have comments' do
    expect(comment.comments).to eq([])
  end

  it 'have author' do
    expect(comment.author).to_not be_nil
  end
end
