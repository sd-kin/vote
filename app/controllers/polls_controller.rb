# frozen_string_literal: true
class PollsController < ApplicationController
  include Accessible

  def index
    @polls = params[:user] ? Poll.where(user_id: params[:user]) : Poll.all
  end

  def ready
    @polls = Poll.ready
  end

  def show
    id = params[:id]
    @already_voted = remembered_ids.include? id.to_i
    @poll = Poll.find(id)
    @rating = @poll.rating
  end

  def new
    @poll = Poll.new
    @poll.options.build
  end

  def edit
    @poll = Poll.find(params[:id])
    check_accessability(@poll)
    @rating = @poll.rating
  end

  def create
    @poll = current_user.polls.new(poll_params)
    @correct = @poll.save
  end

  def update
    @poll = Poll.find(params[:id])
    execute_if_accessible(@poll) { |poll| poll.update poll_params }
  end

  def destroy
    @poll = Poll.find(params[:id])
    execute_if_accessible(@poll, redirect: false, &:destroy)
    redirect_to polls_path
  end

  def choose
    id = params[:id]
    @poll = Poll.find(id)
    unless remembered_ids.include? id.to_i
      @poll.vote! preferences_as_weight(@poll, params[:choices_array])
      remember_id(id)
      @already_voted = true
    end
  end

  def result
    id = params[:id]
    @poll = Poll.find(id)
    @already_voted = remembered_ids.include? id.to_i
  end

  def make_ready
    @poll = Poll.find(params[:id])
    execute_if_accessible(@poll, redirect: false, &:ready!)
    render 'change_status'
  end

  def make_draft
    @poll = Poll.find(params[:id])
    execute_if_accessible(@poll, redirect: false, &:draft!)
    render 'change_status'
  end

  private

  def poll_params
    params.require(:poll).permit(:title)
  end

  def remember_id(id)
    cookies.signed.permanent[:voted_polls] ||= '[]'
    arr = JSON.parse(cookies.signed[:voted_polls])
    arr << id
    cookies.signed[:voted_polls] = JSON.generate(arr.uniq)
  end

  def remembered_ids
    JSON.parse(cookies.signed[:voted_polls] || '[]').map(&:to_i)
  end

  def preferences_as_weight(poll, arr)
    arr = arr.map { |opt| opt.split('_').last.to_i }.reverse
    poll.options.ids.map { |opt_id| arr.index opt_id }
  end
end
