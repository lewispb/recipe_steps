module Journea
  class Engine < ::Rails::Engine
    isolate_namespace Journea

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
      g.assets false
      g.helper false
    end

    initializer :append_migrations do |app|
      # From: https://blog.pivotal.io/labs/labs/leave-your-migrations-in-your-rails-engines
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    initializer :statesman, before: :load_config_initializers do
      Statesman.configure do
        storage_adapter(Statesman::Adapters::ActiveRecord)
      end
    end
  end
end
