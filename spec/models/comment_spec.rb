# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { FactoryGirl.create :comment }
  let(:commented_comment) { FactoryGirl.create :comment, :with_comments }

  it 'have comments' do
    expect(comment.comments).to eq([])
  end

  it 'have author' do
    expect(comment.author).to_not be_nil
  end

  context 'when have replies' do
    context 'can not be deleted' do
      subject { commented_comment.destroy }

      it { is_expected.to be_falsey }

      it 'generate an error' do
        expect { subject }.to change { commented_comment.errors.count }.by(1)
      end
    end
  end

  it 'have rating' do
    expect(comment.rating).to_not be_nil
  end
end
