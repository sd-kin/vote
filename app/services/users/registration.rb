# frozen_string_literal: true
module Services
  module Users
    class Registration
      include Service

      def call(user, user_params)
        user = if user.anonimous?
                 register_anonimous(user, user_params)
               else
                 User.create(user_params)
               end

        UserMailer.account_activation(user).deliver_later if user.errors.empty?

        user
      end

      private

      def register_anonimous(user, user_params)
        user.assign_attributes(user_params)
        user.assign_attributes(anonimous: false) if user.valid?
        user.save

        user
      end
    end
  end
end
