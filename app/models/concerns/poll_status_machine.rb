# frozen_string_literal: true
module PollStatusMachine
  require 'micromachine'

  extend ActiveSupport::Concern

  def configure_machine(initial_state, rules)
    machine = MicroMachine.new(initial_state)               # new state-macine initialized by poll status
    rules.each do |k, v|
      machine.transitions_for[k] = v                        # create rules for changing poll status from Poll::AVAILIBLE_TRANSITIONS
      machine.define_singleton_method k do                  # define method for each possible status
        trigger(k)
      end
    end

    add_callbacks(machine)

    machine
  end

  private

  def add_callbacks(machine)
    machine.on('ready') { check_options_presists(machine) }
  end

  def check_options_presists(machine)
    if options.empty?
      errors.add(:base, "Status can't be ready when poll have no options")
      machine.trigger(:draft)
    end
  end

  # Poll class methods
  module ClassMethods
    def define_status_methods_from(rules)
      rules.each_key do |k| # dynamic generation metods for ceck and change status
        define_change_status_method(k)
        define_check_status_method(k)
        define_check_availability_to_change_status_method(k)
        define_scope_by_status_method(k)
      end
    end

    private

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
      define_method "can_be_#{status_name}?" do # method check if status can be changed from current to method-named
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
