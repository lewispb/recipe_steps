Journea.configure_steps do
  # step :first_step, initial: true
  # step :second_step
  #
  # transition from: :first_step, to: :second
  #
  # before_transition(to: :second_step) do |journea|
  # end

<% @steps.each_with_index do |step, i| -%>
<% if i == 0 -%>
  step :<%= step %>, initial: true
<% else -%>
  step :<%= step %>
<% end -%>
<% end -%>

<% @steps.each_with_index do |step, i| -%>
<% if @steps[i + 1].present? -%>
  transition from: :<%= step %>, to: :<%= @steps[i + 1] %>
<% end -%>
<% end -%>
end
