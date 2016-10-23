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
end
