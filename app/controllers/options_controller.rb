class OptionsController < ApplicationController
  
  def show
    @option = Option.find(params[:id])
    @poll = @option.poll
  end

  def edit
    respond_to do |format|
      format.js { @option = Option.find(params[:id]) ; @poll = @option.poll }
    end
  end


  def create
  	@poll = Poll.find(poll_id)
    @option = @poll.options.build option_params
    @option.save 
  end

  def update 
    @option = Option.find(params[:id])
    @option.update option_params
    respond_to do |format|
      format.js { @poll = Poll.find(poll_id) }
    end
  end

  def destroy
    @option = Option.find(params[:id])
    @poll = Poll.find(poll_id)
    @option.destroy
  end

  private
  
  def option_params
    params.require(:option).permit(:title, :description)
  end

  def poll_id
    params[:poll_id]
  end

  def option_id
    params[:id]
  end

end
