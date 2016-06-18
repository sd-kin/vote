# frozen_string_literal: true
class PollsController < ApplicationController

  def index
    @polls = Poll.all
  end

  def ready_index
    @polls = Poll.ready
  end

  def show
    id = params[:id]
    @already_voted = remembered_ids.include? id.to_i
    @poll = Poll.find(id)
  end

  def new
    @poll = Poll.new
    @poll.options.build
  end

  def edit
    @poll = Poll.find(params[:id])
  end

  def create
    @poll = Poll.new(poll_params)
    @correct = @poll.save
  end

  def update
    @poll = Poll.find(params[:id])
    @poll.update poll_params
  end

  def destroy
    @poll = Poll.find(params[:id])
    @poll.destroy
    redirect_to polls_path
  end

  def choose
    id = params[:id]
    @poll = Poll.find(id)
    save_preferences_as_weight(@poll, params[:choices_array]) unless remembered_ids.include? id.to_i
    remember_id(id)
    @poll.vote!
  end

  def make_ready
    @poll = Poll.find(params[:id])
    @poll.ready!
    render 'change_status'
  end

  def make_draft
    @poll = Poll.find(params[:id])
    @poll.draft!
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

  def save_preferences_as_weight(poll, arr)
    arr = arr.map { |opt| opt.split('_').last.to_i }.reverse
    poll.vote_results << poll.options.ids.map { |opt_id| arr.index opt_id }
    poll.save
  end
end
