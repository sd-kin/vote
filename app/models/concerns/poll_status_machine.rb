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
    save_status(machine)
  end

  def save_status(machine)
    machine.on(:any) do             # after any state change
      self.status = machine.state   # set poll status to current state-machine state
      save!                         # save here instead of in model method becouse no need to reload instance that way
    end
  end
end
