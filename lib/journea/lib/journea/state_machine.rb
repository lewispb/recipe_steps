module Journea
  class StateMachine
    include Statesman::Machine

    def self.step(*args)
      # Instead of using Statesman 'state', this let's us use 'step'
      state(*args)
    end

    def previous_step
      return nil unless last_transition.present?
      last_transition.metadata["previous_state"]
    end

    def next_step
      raise "No next step defined" if allowed_transitions.empty?
      allowed_transitions.first.to_sym
    end

    def transition_to_next_step
      transition_to!(next_step, previous_state: current_state)
    end

    def in_initial_state?
      current_state
    end

    # Monkey patch to prevent hard fail on transitioning between unsupported routes
    def validate_transition(options = { from: nil, to: nil, metadata: nil })
      from = to_s_or_nil(options[:from])
      to   = to_s_or_nil(options[:to])

      # Call all guards, they raise exceptions if they fail
      guards_for(from: from, to: to).each do |guard|
        guard.call(@object, last_transition, options[:metadata])
      end
    end

  end
end
