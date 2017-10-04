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
    id      = params[:id]
    @poll   = Poll.find(id)
    @rating = @poll.rating

    actualize_voted_polls_cookie

    @already_voted = remembered_ids.include?(id.to_i) || @poll.voters.include?(current_user)
  end

  def new
    @poll = Poll.new

    Poll::MINIMUM_OPTIONS_COUNT.times { @poll.options.build }
  end

  def edit
    @poll = Poll.includes(:rating, :images).find(params[:id])

    check_accessability(@poll)

    @rating = @poll.rating
  end

  def create
    @poll = Services::Polls::Create.call(current_user, params)
    if @poll.persisted?
      redirect_to @poll
    else
      flash[:error] = @poll.errors.full_messages
      render :new
    end
  end

  def update
    @poll = Poll.includes(:images).find(params[:id])

    execute_if_accessible(@poll) { |poll| Services::Polls::Update.call(poll, params) }

    # ActionController::Metal#performed? test whether render or redirect already happened
    return if performed?

    if @poll.errors.empty?
      redirect_to @poll
    else
      flash[:error] = @poll.errors.full_messages
      render :edit
    end
  end

  def destroy
    @poll = Poll.find(params[:id])

    execute_if_accessible(@poll, redirect: false, &:delete!)

    redirect_to polls_path
  end

  def choose
    id    = params[:id]
    @poll = Poll.find(id)

    unless remembered_ids.include?(id.to_i) || @poll.voters.include?(current_user)
      preferences = preferences_as_weight(@poll, params[:choices_array])

      @poll.vote!(current_user, preferences)
      actualize_voted_polls_cookie

      @already_voted = true
    end
  end

  def result
    id             = params[:id]
    @poll          = Poll.find(id)
    @already_voted = remembered_ids.include?(id.to_i) || @poll.voters.include?(current_user)
  end

  private

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
