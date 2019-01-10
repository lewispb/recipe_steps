Journea.configure_steps do
  state :name, initial: true
  step :address
  step :phone_number

  transition from: :name,     to: :address
  transition from: :address,  to: :phone_number
end
