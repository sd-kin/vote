# frozen_string_literal: true
module StatusMachine
  InvalidEvent = Class.new(NoMethodError)
  InvalidState = Class.new(ArgumentError)

  include ActiveSupport::Callbacks
  extend  ActiveSupport::Concern

  included do
    private

    attr_accessor :status_machine
  end

  private

  def transitions_for
    self.class.transitions_for
  end

  def change_status(event)
    self.status = transitions_for[event][status] # status does not saved
  end

  def trigger(event)
    trigger?(event) && change_status(event)
  end

  def trigger!(event)
    raise InvalidState, "Event '#{event}' not valid from state '#{status}'" unless trigger(event)
  end

  def trigger?(event)
    raise InvalidEvent unless transitions_for.key?(event)
    transitions_for[event].key?(status)
  end

  # Statusable class methods
  module ClassMethods
    attr_reader :transitions_for

    def availible_status_transitions(rules)
      @transitions_for = rules
      define_status_callbacks
      define_status_callbacks_methods
      define_status_methods
    end

    private

    def define_status_callbacks
      define_callbacks *(status_events.map(&:to_sym) << :change_status) # define callbacks for each status plus :change_status.
    end

    def define_status_callbacks_methods # add class methods for setting callback.
      %w(before_ after_ around_).each do |prefix|
        define_singleton_method "#{prefix}change_status" do |method|
          set_callback :change_status, prefix.chop.to_sym, method
        end

        status_events.each do |event|
          define_singleton_method "#{prefix}#{event}" do |*methods| # TODO: accept block as callback parameter
            methods.each do |method|
              set_callback event.to_sym, prefix.chop.to_sym, method
            end
          end
        end
      end
    end

    def define_status_methods
      transitions_for.each_key do |k| # dynamic generation methods for check and change status
        define_transition(k)
        define_check_availability_to_change_status_method(k)
      end
      statuses.each do |k|
        define_check_status_method(k)
        define_scope_by_status_method(k)
      end
    end

    def define_transition(transition_name)
      define_method "#{transition_name}!" do # methods with ! change status to status of the same name
        run_callbacks :change_status do
          run_callbacks transition_name.to_sym do
            return if errors.any?
            trigger(transition_name)
            save
          end
        end
      end
    end

    def define_check_status_method(status_name)
      define_method "#{status_name}?" do # method with ? check if current status equal with method-named status
        status == status_name.to_s
      end
    end

    def define_check_availability_to_change_status_method(transition_name)
      define_method "able_to_#{transition_name}?" do # method check if status can be changed from current to method-named
        trigger?(transition_name)
      end
    end

    def define_scope_by_status_method(status_name)
      define_singleton_method status_name.to_s do # scoping polls by each status
        where(status: status_name)
      end
    end

    def status_events
      transitions_for.keys
    end

    def statuses
      transitions_for.values.map(&:to_a).flatten.uniq
    end
  end
end
