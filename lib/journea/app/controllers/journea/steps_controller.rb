module Journea
  class StepsController < EngineController

    before_action :set_journey

    def edit
      @step = current_step_class.new(@journea.data_for_form(current_step_class.new))
      @step.journey = @journea
      render template: @step.step_name
    end

    def update
      @step = current_step_class.new(form_params)
      @step.pre_save(form_params)
      @step.journey = @journea
      if @journea.save_data(@step)
        @journea.transition_to_next_step
        redirect_to edit_journey_step_path(@journea, @journea.state_machine.current_state)
      else
        render template: @step.step_name
      end
    end

    private

    def set_journey
      @journea = model.find(params[:journey_id])

      requested_state = params[:id]
      return unless requested_state != @journea.current_state

      @journea.transition_to!(requested_state)
    end

    def current_step_class
      class_name = "#{@journea.current_state}_step".classify
      begin
        class_name.constantize
      rescue NameError
        # If no custom class is available then use the default
        klass = Step
        klass.custom_name = @journea.current_state
        klass
      end
    end

    def form_params
      params.fetch(current_step_class.step_name.to_sym, {}).permit(current_step_class.permitted_params)
    end

  end
end
