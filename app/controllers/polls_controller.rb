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

  def make_choise
    id = params[:id]
    @poll = Poll.find(id)
    @poll.save_preferences_as_weight params[:choise_array] unless remembered_ids.include? id.to_i
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
    cookies[:voted_polls] ||= []
    arr = JSON.parse(cookies[:voted_polls])
    arr << id
    cookies[:voted_polls] = JSON.generate(arr.uniq)
  end

  def remembered_ids
    JSON.parse(cookies[:voted_polls]).map(&:to_i)
  end
end
