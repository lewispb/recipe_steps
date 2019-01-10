module Journea
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    def init
      @steps = []
      @install_assets = false
    end

    def setup_deps
      @install_assets = yes?("Do you want to install the GOV.UK styles?")
      if @install_assets
        gem "govuk_template"
        gem "govuk_frontend_toolkit"
        gem "govuk_elements_rails"
      end
      gem "haml-rails", "~> 0.9"
      Bundler.with_clean_env do
        run "bundle install"
      end
    end

    def setup_assets
      return unless @install_assets

      copy_file "views/application.html.haml", "app/views/layouts/application.html.haml"
      remove_file "app/views/layouts/application.html.erb"
      copy_file "assets/application.js", "app/assets/javascripts/application.js"
      copy_file "assets/application.scss", "app/assets/stylesheets/application.scss"
      remove_file "app/assets/stylesheets/application.css"
    end

    def create_start_page
      return unless yes?("Do you need a start page?")

      puts "Generating start page..."
      copy_file "views/pages/start.html.haml.example", "app/views/pages/start.html.haml"
      copy_file "controllers/pages_controller.rb.example", "app/controllers/pages_controller.rb"
      route "root 'pages#start'"
    end

    def generate_steps
      begin
        puts "How many steps do you need to generate?"
        step_number = gets.chomp
        step_number = Integer(step_number)
      rescue
        print "Please enter an integer number:"
        retry
      end

      if step_number > 0
        copy_file "views/shared/error_messages.html.haml.example", "app/views/shared/_error_messages.html.haml"
      end

      step_number.times do |i|
        name = ask "What is the name of step #{i + 1}?"
        puts "Generating #{name} step..."
        @name = name.downcase.strip
        @steps << name
        create_file "app/steps/#{@name}_step.rb", "class #{name.capitalize}Step < Journea::Step \nend"
        template "views/steps/step.html.haml.example", "app/views/steps/#{@name}.html.haml"
      end
    end

    def create_initializer
      puts "generating initializer"
      inside "config" do
        inside "initializers" do
          template "journea.rb"
        end
      end
      route "mount Journea::Engine, at: '/journey'"
    end
  end
end
