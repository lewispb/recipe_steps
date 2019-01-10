Journea.configure_steps do
  # step :first_step, initial: true
  # step :second_step
  #
  # transition from: :first_step, to: :second
  #
  # before_transition(to: :second_step) do |journea|
  # end

  step :title, initial: true
  step :picture
  step :ingredients
  step :step_1
  step :more_steps
  step :story
  step :review
  step :publish

  transition from: :title, to: :picture
  transition from: :picture, to: :ingredients
  transition from: :ingredients, to: :step_1
  transition from: :step_1, to: :more_steps
  transition from: :more_steps, to: :story
  transition from: :story, to: :review
  transition from: :review, to: :publish
end
