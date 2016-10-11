# frozen_string_literal: true
class CommentsController < ApplicationController
  include Accessible

  before_action :set_commentable

  def new
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
    @commentable = Poll.find(params[:poll_id]) if params[:poll_id]
    @commentable = Comment.find(params[:comment_id]) if params[:comment_id]
  end
end
