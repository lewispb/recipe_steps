module Journea
  class Journey < ActiveRecord::Base

    include Statesman::Adapters::ActiveRecordQueries

    has_many :journea_journey_transitions, class_name: "Journea::JourneyTransition", autosave: false
    has_many :journea_keyvalues, class_name: "Journea::Keyvalue"

    # State Machine related

    def state_machine
      @state_machine ||= StateMachine.new(self, transition_class: JourneyTransition)
    end

    delegate :can_transition_to?,
             :transition_to!,
             :transition_to,
             :current_state,
             :transition_to_next_step,
             :previous_step,
             :in_initial_state?,
             to: :state_machine

    def self.transition_class
      Journea::JourneyTransition
    end
    private_class_method :transition_class

    # Instance methods

    def save_data(step_object)
      return false unless step_object.valid?
      step_object.attributes.each do |k, v|
        key_value_pair = Keyvalue.find_or_initialize_by(key: k.to_s, journey: self)
        key_value_pair.value = v
        key_value_pair.save
      end

      true
    end

    def data_for_form(step_object)
      data = Keyvalue.where(key: step_object.attributes.keys, journey: self).map do |kv|
        [kv.key.to_sym, kv.value]
      end
      data.to_h
    end

    def data
      Data.new(Keyvalue.where(journey: self))
    end

  end
end
