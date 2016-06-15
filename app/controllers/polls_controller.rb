# frozen_string_literal: true
class PollsController < ApplicationController

  def index
    @polls = Poll.all
  end

  def ready_index
    @polls = Poll.ready
  end

  def show
    @poll = Poll.find(params[:id])
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
    @poll = Poll.find(params[:id])
    @poll.save_preferences_as_weight params[:choise_array]
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
end
