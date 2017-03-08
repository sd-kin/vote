# frozen_string_literal: true
class ImagesController < ApplicationController
  include Accessible

  def destroy
    @image   = Image.find(params[:id])
    @success = execute_if_accessible(@image, redirect: false, &:destroy)
  end
end
