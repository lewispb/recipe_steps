# Auto require all dependencies in the gemspec
Gem.loaded_specs["journea"].dependencies.each do |d|
  begin
    require d.name

    # At this point in time unsure why exceptions are being swallowed here so
    # am having to disable the cop for this section of code.
    # rubocop:disable Lint/HandleExceptions
  rescue(LoadError)
    # Gem require failed
    # puts "Couldn't require #{d.name}"
  end
  # rubocop:enable Lint/HandleExceptions
end

require "journea/engine"
require "journea/step"
require "journea/state_machine"
require "journea/data"

module Journea
  def self.configure_steps(&block)
    StateMachine.class_eval(&block)
  end
end
