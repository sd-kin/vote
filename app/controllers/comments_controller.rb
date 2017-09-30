# frozen_string_literal: true

class CommentsController < ApplicationController
  include Accessible

  def show
    @comment = Comment.find(params[:id])
  end

  def new
    @commentable = Comment.find params[:comment_id]
    @comment = @commentable.comments.build(parent_id: @commentable.id)
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    @updated = execute_if_accessible(@comment, redirect: false) { |c| Services::Comments::Update.call(c, params) }
  end

  def create
    @comment = current_user.comments.build comment_params
    @comment.parent_id = @comment.commentable_id if comment_params[:commentable_type] == 'Comment'
    @created = execute_if_accessible(@comment, redirect: false, &:save)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @deleted = execute_if_accessible(@comment, redirect: false, &:destroy)
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type, images: [])
  end
end
