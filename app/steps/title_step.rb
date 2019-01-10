class TitleStep < Journea::Step
  validates :title, presence: true
  attribute :title, :string
  # attribute :address_line2, :string
  # attribute :city, :string
  # attribute :postcode, :string
  # attribute :is_business_address, :boolean
  # attribute :created_date, :datetime, default: Time.now
  # validates :address_line1, :address_line2, presence: true
end
