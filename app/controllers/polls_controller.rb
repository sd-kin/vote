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

  def create
    if @poll.save then redirect_to edit_poll_path(@poll)
    else render :new
    end 
  end

  private

  def set_poll
  @poll = if params[:id] then Poll.find(params[:id])
            elsif params[:poll] then Poll.new(poll_params)
            else Poll.new
            end
  end

  def poll_params
    params.require(:poll).permit(:title)
  end

end
