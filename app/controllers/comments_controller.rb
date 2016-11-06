# frozen_string_literal: true
class CommentsController < ApplicationController
  include Accessible

  before_action :set_commentable

  def show
    @comment = Comment.find(params[:id])
  end

  def new
    @comment = @commentable.comments.build
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    @updated = execute_if_accessible(@comment, redirect: false) { |c| c.update comment_params }
  end

  def create
    @comment = @commentable.comments.build comment_params
    @comment.author = current_user
    @created = execute_if_accessible(@comment, redirect: false, &:save)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @deleted = execute_if_accessible(@comment, redirect: false, &:destroy)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    @commentable = poll_from_params || comment_from_params
  end

  def comment_from_params
    Comment.find(params[:comment_id]) if params[:comment_id]
  end

  def poll_from_params
    Poll.find(params[:poll_id]) if params[:poll_id]
  end
end
