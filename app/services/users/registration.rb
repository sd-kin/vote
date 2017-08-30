# frozen_string_literal: true
module Services
  module Users
    class Registration
      # look up in concerns folder
      include Service

      def call(user, user_params)
        user = if user&.anonimous?
                 register_anonimous(user, user_params)
               else
                 User.create(user_params)
               end

        UserMailer.account_activation(user).deliver_later if user.errors.empty?

        # check password presence only during registration process because adding that to model validations
        # lead to validation errors when user autosaved by ActiveRecord associations
        user.errors.messages[:password] = ["can't be blank"] if user.password.blank?

        user
      end

      private

      def register_anonimous(user, user_params)
        user.assign_attributes(user_params)
        user.assign_attributes(anonimous: false) if user.valid?
        user.save

        # because of any anonymous user is a persisted user
        # form will be submitted to #edit action if it rendered with errors after #create
        # that dirty hack make it look like new and not so messy as explicit url options in form
        user.instance_variable_set(:@new_record, true) unless user.valid?

        user
      end
    end
  end
end
