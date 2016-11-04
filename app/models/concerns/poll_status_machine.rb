# frozen_string_literal: true
module PollStatusMachine
  require 'micromachine'

  extend ActiveSupport::Concern

  def configure_machine(initial_state)
    machine = PollMicroMachine.new(initial_state) # new state-machine initialized by poll status

    add_callbacks(machine)

    machine
  end

  private

  def add_callbacks(machine)
    machine.on('ready') { check_options_presists(machine) }
    machine.on('draft') { drop_votation_progress }
  end

  def check_options_presists(machine)
    if options.empty?
      errors.add(:base, "Status can't be ready when poll have no options")
      machine.trigger(:draft)
    end
  end

  # Poll class methods
  module ClassMethods
    def availible_status_transitions(rules)
      generate_status_machine_class(rules)
      define_status_methods_from(rules)
    end

    private

    def generate_status_machine_class(rules) # generate class for status machine with included list of available transitions
      PollStatusMachine.const_set(:PollMicroMachine, Class.new(MicroMachine))
      PollMicroMachine.send :define_method, :initialize do |status|
        super(status)
        @transitions_for = rules
      end
    end

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
