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
    @poll = Poll.find(id)
    @rating = @poll.rating
    actualize_voted_polls_cookie
    @already_voted = remembered_ids.include?(id.to_i) || @poll.voters.include?(current_user)
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
    @rating = @poll.rating
    execute_if_accessible(@poll) { |poll| poll.update poll_params }
  end

  def destroy
    @poll = Poll.find(params[:id])
    execute_if_accessible(@poll, redirect: false, &:delete!)
    redirect_to polls_path
  end

  def choose
    id = params[:id]
    @poll = Poll.find(id)
    unless remembered_ids.include?(id.to_i) || @poll.voters.include?(current_user)
      preferences = preferences_as_weight(@poll, params[:choices_array])
      @poll.vote!(current_user, preferences)
      actualize_voted_polls_cookie
      @already_voted = true
    end
  end

  def result
    id = params[:id]
    @poll = Poll.find(id)
    @already_voted = remembered_ids.include?(id.to_i) || @poll.voters.include?(current_user)
  end

  def make_ready
    @poll = Poll.find(params[:id])
    execute_if_accessible(@poll, redirect: false, &:ready!)
    render 'change_status'
  end

  def make_draft
    id = params[:id]
    @poll = Poll.find(id)
    execute_if_accessible(@poll, redirect: false, &:draft!)
    actualize_voted_polls_cookie
    render 'change_status'
  end

  private

  def poll_params
    params.require(:poll).permit(:title, :max_voters, :expire_at, images: [])
  end

  def actualize_voted_polls_cookie
    current_user.reload
    cookies.signed[:voted_polls] = JSON.generate(current_user.voted_polls.ids)
  end

  def remembered_ids
    JSON.parse(cookies.signed[:voted_polls] || '[]').map(&:to_i)
  end

  def preferences_as_weight(poll, arr)
    arr = arr.map { |opt| opt.split('_').last.to_i }.reverse
    poll.options.ids.map { |opt_id| arr.index opt_id }
  end
end
