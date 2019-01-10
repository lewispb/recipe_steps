module Journea
  class JourneysController < EngineController

    def create
      journey = model.create
      redirect_to edit_journey_step_path(journey, journey.state_machine.current_state)
    end

  end
end
