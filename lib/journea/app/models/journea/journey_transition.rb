module Journea
  class JourneyTransition < ActiveRecord::Base
    include Statesman::Adapters::ActiveRecordTransition

    belongs_to :journey, inverse_of: :journea_journey_transitions

    after_destroy :update_most_recent, if: :most_recent?

    private

    def update_most_recent
      last_transition = journey.journey_transitions.order(:sort_key).last
      return unless last_transition.present?
      last_transition.update_column(:most_recent, true)
    end
  end
end
