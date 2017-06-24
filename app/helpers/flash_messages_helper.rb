# frozen_string_literal: true
module FlashMessagesHelper
  def bootstrap_class_for(flash_type)
    { success: 'alert-success', error: 'alert-danger', alert: 'alert-warning', notice: 'alert-info' }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def render_flash_messages
    capture do # capture html content to add as separate strings
      flash.each do |type, messages|
        messages = [messages] unless messages.is_a?(Array)
        messages.each do |msg|
          concat render 'shared/flash_message', type: type, message: msg # concat adds new messages to existing elements
        end
      end
    end
  end
end
