# encoding: utf-8
# frozen_string_literal: true
class OptionsController < ApplicationController

  def show
    @option = Option.find(params[:id])
  end

  def edit
    @option = Option.find(params[:id])
  end

  def create
    @option = Option.create option_params.merge(poll_id: poll_id)
  end

  def update
    @option = Option.find(params[:id])
    @option.update option_params
  end

  def destroy
    @option = Option.find(params[:id])
    @option.destroy
  end

  private

  def option_params
    params.require(:option).permit(:title, :description)
  end

  def poll_id
    params[:poll_id]
  end
end
