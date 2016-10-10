# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:comment) { FactoryGirl.create :comment }
  let(:comments_params) { FactoryGirl.attributes_for :comment }
  let(:poll) { FactoryGirl.create :valid_poll }
  let(:user) { FactoryGirl.create :user }
  let(:anonimous_user){ User.create_anonimous! }

  describe 'GET#new' do
    subject { xhr :get, :new, comment: comment }

    it { is_expected.to be_success }
  end

  describe 'POST#create' do
    before(:each) { session[:user_id] = user.id }

    context 'when poll commented' do
      subject { xhr :post, :create, poll_id: poll, comment: comments_params }

      it { is_expected.to be_success }

      it 'have poll as commentable' do
        subject
        expect(assigns(:commentable)).to be_a(Poll)
      end

      it 'increase comments counter' do
        expect { subject }.to change { Comment.count }.by(1)
      end

      it 'increase polls comments counter' do
        expect { subject }.to change { poll.reload.comments.count }.by(1)
      end
    end

    context 'when comment commented' do
      subject { xhr :post, :create, comment_id: comment, comment: comments_params }

      it { is_expected.to be_success }

      it 'have comment as commentable' do
        subject
        expect(assigns(:commentable)).to be_a(Comment)
      end

      it 'increase comments counter' do
        expect { subject }.to change { Comment.count }.by(1)
      end

      it 'increase polls comments counter' do
        expect { subject }.to change { comment.reload.comments.count }.by(1)
      end
    end

    context 'when user logged in' do
      subject { xhr :post, :create, comment_id: comment, comment: comments_params }
      before(:each) { session[:user_id] = user.id }

      it 'create comment with author' do
        subject
        expect(assigns(:comment).author).to eq(user)
      end
    end

    context 'when user not login in' do
      before(:each) { session[:user_id] = anonimous_user.id }
      subject { xhr :post, :create, comment_id: comment, comment: comments_params }

      it 'not create comment' do
        expect { subject }.to_not change { Comment.count }
      end
    end
  end
end
