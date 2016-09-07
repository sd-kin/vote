# frozen_string_literal: true
class OptionsController < ApplicationController
  include Accessible

  def show
    @option = Option.find(params[:id])
  end

  def edit
    @option = Option.find(params[:id])
    execute_if_accessible(subject: @option)
  end

  def create
    @option = poll.options.new option_params
    execute_if_accessible(subject: @option, &:save)
  end

  def update
    @option = Option.find(params[:id])
    execute_if_accessible(subject: @option) { |option| option.update option_params }
  end

  def destroy
    @option = Option.find(params[:id])
    execute_if_accessible(subject: @option, redirect: false, &:destroy)
  end

  private

  def option_params
    params.require(:option).permit(:title, :description)
  end

  def poll
    Poll.find(params[:poll_id])
  end
end
