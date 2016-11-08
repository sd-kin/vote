# frozen_string_literal: true
class SimpleMachine
  InvalidEvent = Class.new(NoMethodError)
  InvalidState = Class.new(ArgumentError)

  attr_reader :state

  class << self
    attr_accessor :transitions_for
  end

  @transitions_for = {}

  def initialize(initial_state)
    @state = initial_state
  end

  def trigger(event)
    trigger?(event) && change(event)
  end

  def trigger!(event)
    raise InvalidState, "Event '#{event}' not valid from state '#{@state}'" unless trigger(event)
  end

  def trigger?(event)
    raise InvalidEvent unless transitions_for.key?(event)
    transitions_for[event].key?(state)
  end

  def events
    transitions_for.keys
  end

  def states
    transitions_for.values.map(&:to_a).flatten.uniq
  end

  private

  def transitions_for
    self.class.transitions_for
  end

  def change(event)
    @state = transitions_for[event][@state]
  end
end
