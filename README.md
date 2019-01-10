# Journea (Alpha)

[![Build Status](https://travis-ci.org/DEFRA/journea.svg?branch=master)](https://travis-ci.org/DEFRA/journea)
[![Code Climate](https://codeclimate.com/github/DEFRA/journea/badges/gpa.svg)](https://codeclimate.com/github/DEFRA/journea)
[![Test Coverage](https://codeclimate.com/github/DEFRA/journea/badges/coverage.svg)](https://codeclimate.com/github/DEFRA/journea/coverage)
[![security](https://hakiri.io/github/DEFRA/journea/master.svg)](https://hakiri.io/github/DEFRA/journea/master)
[![Dependency Status](https://dependencyci.com/github/DEFRA/journea/badge)](https://dependencyci.com/github/DEFRA/journea)
[![Gem Version](https://badge.fury.io/rb/journea.svg)](https://badge.fury.io/rb/journea)

**Journea** is a Ruby on Rails engine (tested on Rails 5 only) which you can use to define steps and the transitions between them. Each step (or page) is tracked in a state machine, [Statesman](https://github.com/gocardless/statesman).

**Journea** handles rendering the views you design and the transitions between them are defined in an initializer.

## Installation

Add the gem to your gemfile.

Run the install generator and answer the questions

```
# Only use in new, fresh Rails projects
rails generate journea:install
```

## Getting started

For each step you need to setup a state in the state machine

```ruby
# config/initializers/journea.rb

Journea.configure_steps do
  step :import_or_export, initial: true
  step :company_type
  step :limited_company_details
  step :company_address
  step :finish

  transition from: :import_or_export,         to: :company_type
  transition from: :company_type,             to: [:limited_company_details, :company_address]
  transition from: :limited_company_details,  to: :company_address
  transition from: :company_address,          to: :finish

  guard_transition(to: :limited_company_details) do |journea|
    journea.data.is_limited_company?
  end

  after_transition(to: :finish) do |journea|
    Mailer.application_details(journea.data).deliver
  end
end
```

Each step can optionally have a step object, based on [simple form object](https://github.com/reinteractive-open/simple_form_object):

```ruby
# app/steps/company_address_step.rb

class CompanyAddress < Journea::Step
  attribute :address_line1, :string
  attribute :address_line2, :string
  attribute :city, :string
  attribute :postcode, :string
  attribute :is_business_address, :boolean

  attribute :created_date, :datetime, default: Time.now

  validates :address_line1, :address_line2, presence: true
end
```

And each step needs a view

```ruby

# app/views/layouts/application.html.haml

# Optional back link helper can be used anywhere

= render 'back_link'

# app/views/steps/company_address.html.haml

.grid-row
  .column-two-thirds
    = simple_form_for @form do |f|
      = render 'shared/error_messages'

      %h1.heading-large What is your company address?

      = f.input :address_line1
      = f.input :address_line2, hint: 'Optional'
      = f.input :city
      = f.input :postcode
      = f.input :is_business_address

      = f.button :submit, 'Continue'

```

You can access data stored against the journey object like so

```ruby
  journey = Journea::Journey.find(1)
  puts journey.data.certifcate_type

  # or
  puts @journea.data.certifcate_type
```

## Contributing to this project

If you have an idea you'd like to contribute please log an issue.

All contributions should be submitted via a pull request.

## License

THIS INFORMATION IS LICENSED UNDER THE CONDITIONS OF THE OPEN GOVERNMENT LICENCE found at:

http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3

The following attribution statement MUST be cited in your products and applications when using this information.

> Contains public sector information licensed under the Open Government license v3

### About the license

The Open Government Licence (OGL) was developed by the Controller of Her Majesty's Stationery Office (HMSO) to enable information providers in the public sector to license the use and re-use of their information under a common open licence.

It is designed to encourage use and re-use of information freely and flexibly, with only a few conditions.
