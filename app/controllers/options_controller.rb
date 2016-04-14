class OptionsController < ApplicationController

  def create
  	@poll = Poll.find(poll_id)
    @option = @poll.options.build option_params
    @option.save 
    render 'polls/edit'
  end

  private
  
  def option_params
    params.require(:option).permit(:title, :description)
  end

  def poll_id
    params.permit(:poll_id)[:poll_id]
  end

end
