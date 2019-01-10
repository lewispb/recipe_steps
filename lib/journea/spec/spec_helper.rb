require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require "simplecov"
SimpleCov.start do
  # any custom configs like groups and filters can be here at a central place

  # The templates folder is used by the generator when initialising a project.
  # This means the code is written to be placed inside a project, and not
  # actually part of this project hence the exclusion
  add_filter "/lib/generators/journea/templates/"

  # It's standard to ignore the spec folder when determining coverage
  add_filter "/spec/"

  # You can make Simplecov ignore sections of by wrapping them in # :nocov:
  # tags. However without knowledge of this `nocov` doesn't mean a lot so here
  # we take advantage of a feature that allows us to use a custom token to do
  # the same thing `nocov` does. Now in our code any sections we want to exclude
  # from test coverage stats we wrap in # :simplecov_ignore: tokens.
  # https://github.com/colszowka/simplecov#ignoringskipping-code
  nocov_token "simplecov_ignore"
end

ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../dummy/config/environment.rb", __FILE__)
require "rspec/rails"
require "capybara/rails"
require "capybara/rspec"
require "factory_girl_rails"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.infer_spec_type_from_file_location!
end
