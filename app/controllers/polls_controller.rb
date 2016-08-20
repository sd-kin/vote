# frozen_string_literal: true
class PollsController < ApplicationController

  def index
    @polls = Poll.all
  end

  def ready
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
    @poll = Poll.new(poll_params.merge(user_id: current_user.id))
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
    if @poll.accessible_for?(current_user)
      @poll.ready!
    else
      @poll.errors.add(:access_denied, 'only owner can do that')
    end
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

  def preferences_as_weight(poll, arr)
    arr = arr.map { |opt| opt.split('_').last.to_i }.reverse
    poll.options.ids.map { |opt_id| arr.index opt_id }
  end
end
