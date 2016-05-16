class PollsController < ApplicationController

  before_filter :set_poll

  def index
    @polls = Poll.all
  end

  def show

  end

  def new
    @poll.options.build
  end

  def edit
    
  end

  def create
    if @poll.save then @correct = true #redirect_to edit_poll_path(@poll)
    else @correct = false #render :new
    end 
  end

  def update
    @poll.update poll_params
  end

  def destroy
    @poll.destroy
    redirect_to polls_path
  end

  def make_ready
    @poll.make_ready
    render 'change_status'
  end

  def make_draft
    @poll.make_draft
    render 'change_status'
  end

  private

  def set_poll
  @poll = if params[:poll_id] then Poll.find(params[:poll_id])
            elsif params[:id] then Poll.find(params[:id])
            elsif params[:poll] then Poll.new(poll_params)
            else Poll.new
            end
  end

  def poll_params
    params.require(:poll).permit(:title)
  end
end
