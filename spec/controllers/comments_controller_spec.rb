# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:comment) { FactoryGirl.create :comment }
  let(:commented_comment) { FactoryGirl.create :comment, :with_comments }
  let(:comment_params) { FactoryGirl.attributes_for :comment }
  let(:poll) { FactoryGirl.create :valid_poll }
  let(:user) { FactoryGirl.create :user }
  let(:anonimous_user) { User.create_anonimous! }

  describe 'GET#new' do
    subject { xhr :get, :new, comment_id: comment }

    it { is_expected.to be_success }
  end

  describe 'POST#create' do
    before(:each) { session[:user_id] = user.id }

    context 'when poll commented' do
      subject { xhr :post, :create, poll_id: poll, comment: comment_params }

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
      subject { xhr :post, :create, comment_id: comment, comment: comment_params }

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
      subject { xhr :post, :create, comment_id: comment, comment: comment_params }
      before(:each) { session[:user_id] = user.id }

      it 'create comment with author' do
        subject
        expect(assigns(:comment).author).to eq(user)
      end
    end

    context 'when user not login in' do
      before(:each) { session[:user_id] = anonimous_user.id }
      subject { xhr :post, :create, comment_id: comment, comment: comment_params }

      it 'not create comment' do
        expect { subject }.to_not change { Comment.count }
      end
    end
  end

  describe 'DELETE#destroy' do
    before(:each) { session[:user_id] = user.id }
    subject { xhr :delete, :destroy, id: comment }

    context 'when user owe comment' do
      before(:each) { comment.update_attribute(:author, user) }

      it 'decrease comments counter' do
        expect { subject }.to change { Comment.count }.by(-1)
      end
    end

    context 'when user does not owe comment' do
      it 'not change comments counter' do
        expect { subject }.to_not change { Comment.count }
      end
    end
  end

  describe 'PUT#update' do
    before(:each) { session[:user_id] = user.id }
    let!(:comment_for_update) { commented_comment.comments.first }
    subject { xhr :put, :update, id: comment_for_update, comment_id: commented_comment, comment: comment_params }

    context 'when user owe comment' do
      before(:each) { comment_for_update.update_attribute(:author, user) }

      it 'can change comment body' do
        expect { subject }.to change { comment_for_update.reload.body }.to(comment_params[:body])
      end
    end

    context 'when user does not owe comment' do
      it 'can not change comment body' do
        expect { subject }.to_not change { comment_for_update.body }
      end
    end
  end
end
