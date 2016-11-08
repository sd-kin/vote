# frozen_string_literal: true
module StatusMachine
  require "#{Rails.root}/lib/simple_machine/simple_machine.rb"

  extend ActiveSupport::Concern

  included do
    # in order to have status_machine whith correct state
    after_initialize { initialize_status_machine } # new state-machine when build statusable object
    after_create     { initialize_status_machine } # new state-machine when create statusable object
    after_find       { initialize_status_machine } # new state-machine when initialize existing statusable object

    private

    attr_accessor :status_machine
  end

  private

  def initialize_status_machine
    self.status_machine = SimpleMachine.new(status)
  end

  # Statusable class methods
  module ClassMethods
    def availible_status_transitions(rules)
      SimpleMachine.transitions_for = rules
      define_status_methods_from(rules)
    end

    private

    def define_status_methods_from(rules)
      statuses = rules.values.map(&:to_a).flatten.uniq
      rules.each_key do |k| # dynamic generation methods for check and change status
        define_change_status_method(k)
        define_check_availability_to_change_status_method(k)
      end
      statuses.each do |k|
        define_check_status_method(k)
        define_scope_by_status_method(k)
      end
    end

    def define_change_status_method(status_name)
      define_method "#{status_name}!" do       # methods with ! change status to status of the same name
        status_machine.trigger(status_name)
        self.status = status_machine.state
        save if errors.empty?
      end
    end

    def define_check_status_method(status_name)
      define_method "#{status_name}?" do       # method with ? check if current status equal with method-named status
        status == status_name.to_s
      end
    end

    def define_check_availability_to_change_status_method(status_name)
      define_method "able_to_#{status_name}?" do # method check if status can be changed from current to method-named
        status_machine.trigger?(status_name)
      end
    end

    def define_scope_by_status_method(status_name)
      define_singleton_method status_name.to_s do # scoping polls by each status
        where(status: status_name)
      end
    end
  end
end
