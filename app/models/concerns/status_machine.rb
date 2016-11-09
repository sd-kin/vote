# frozen_string_literal: true
module StatusMachine
  InvalidEvent = Class.new(NoMethodError)
  InvalidState = Class.new(ArgumentError)

  extend ActiveSupport::Concern

  included do
    private

    attr_accessor :status_machine
  end

  private

  def transitions_for
    self.class.transitions_for
  end

  def change_status(event)
    self.status = transitions_for[event][status] # status did not saved
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
      define_status_methods_from(rules)
    end

    private

    def define_status_methods_from(rules)
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
        trigger(status_name)
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
        trigger?(status_name)
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
