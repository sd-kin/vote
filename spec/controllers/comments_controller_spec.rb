# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:comment) { FactoryGirl.create :comment }
  let(:commented_comment) { FactoryGirl.create :comment, :with_comments }
  let(:poll_comment_params) do
    FactoryGirl.attributes_for(:comment).merge(commentable_id: comment.commentable_id, commentable_type: comment.commentable.class)
  end
  let(:comment_comment_params) do
    FactoryGirl.attributes_for(:comment).merge(commentable_id: comment.id, commentable_type: comment.class)
  end
  let(:poll) { comment.commentable }
  let(:user) { FactoryGirl.create :user }
  let(:anonimous_user) { User.create_anonimous! }

  describe 'GET#new' do
    subject { get :new, xhr: true, params: { comment_id: comment } }

    it { is_expected.to be_success }
  end

  describe 'POST#create' do
    before(:each) { session[:user_id] = user.id }

    context 'when poll commented' do
      subject { post :create, xhr: true, params: { comment: poll_comment_params } }

      it { is_expected.to be_success }

      it 'have poll as commentable' do
        subject
        expect(assigns(:comment).commentable).to be_a(Poll)
      end

      it 'increase comments counter' do
        expect { subject }.to change { Comment.count }.by(1)
      end

      it 'increase polls comments counter' do
        expect { subject }.to change { poll.reload.comments.count }.by(1)
      end
    end

    context 'when comment commented' do
      subject { post :create, xhr: true, params: { comment: comment_comment_params } }

      it { is_expected.to be_success }

      it 'have comment as commentable' do
        subject
        expect(assigns(:comment).commentable).to be_a(Comment)
      end

      it 'increase comments counter' do
        expect { subject }.to change { Comment.count }.by(1)
      end

      it 'increase polls comments counter' do
        expect { subject }.to change { comment.reload.comments.count }.by(1)
      end
    end

    context 'when user logged in' do
      subject { post :create, xhr: true, params: { comment: poll_comment_params } }

      it 'create comment with author' do
        subject
        expect(assigns(:comment).author).to eq(user)
      end
    end

    context 'when user is not login in' do
      before(:each) { session[:user_id] = anonimous_user.id }
      subject { post :create, xhr: true, params: { comment: poll_comment_params } }

      it 'not create comment' do
        expect { subject }.to_not change { Comment.count }
      end
    end
  end

  describe 'DELETE#destroy' do
    before(:each) { session[:user_id] = user.id }
    subject { delete :destroy, xhr: true, params: { id: comment } }

    context 'when user owns comment' do
      before(:each) { comment.update_attribute(:author, user) }

      it 'decrease comments counter' do
        expect { subject }.to change { Comment.count }.by(-1)
      end
    end

    context 'when user does not owns comment' do
      it 'not change comments counter' do
        expect { subject }.to_not change { Comment.count }
      end
    end
  end

  describe 'PUT#update' do
    before(:each) { session[:user_id] = user.id }
    let!(:comment_for_update) { commented_comment.comments.first }
    subject { put :update, xhr: true, params: { id: comment_for_update, comment: comment_comment_params } }

    context 'when user owns comment' do
      before(:each) { comment_for_update.update_attribute(:author, user) }

      it 'can change comment body' do
        expect { subject }.to change { comment_for_update.reload.body }.to(comment_comment_params[:body])
      end
    end

    context 'when user does not owns comment' do
      it 'can not change comment body' do
        expect { subject }.to_not change { comment_for_update.body }
      end
    end
  end
end
