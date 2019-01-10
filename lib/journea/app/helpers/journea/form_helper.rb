module Journea
  module FormHelper

    # So that we don't have to put url: on every simple form, override the url
    # generator
    def polymorphic_path(*args)
      if args.present?
        record = args.first
        return journey_step_path(@journea, @step.step_name) if record.is_a? Step
      end
      super(*args)
    end

    def link_to_input_with_error(element, messages)
      capture do
        messages.map do |message|
          concat(content_tag(:li) do
            link_to message, "##{@step.step_name}_#{element}"
          end)
        end
      end
    end

  end
end
