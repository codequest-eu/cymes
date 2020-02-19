require 'devise'

module Fae
  class Engine < ::Rails::Engine
    isolate_namespace Fae

    # include libraries
    require 'simple_form'
    require 'remotipart'
    require 'jquery-rails'
    require 'jquery-ui-rails'
    require 'judge'
    require 'judge/simple_form'
    require 'acts_as_list'
    require 'slim'
    require 'kaminari'
    require 'fae/version'

    config.autoload_paths += %W(#{config.root}/app/models/concerns/fae)
    # Dir["#{config.root}/lib/**/"].each { |f| require f }

    config.to_prepare do
      # Require decorators from main application
      Dir.glob(Rails.root.join('app', 'decorators', '**', '*_decorator.rb')).each do |decorator|
        Rails.configuration.cache_classes ? require(decorator) : load(decorator)
      end

      # Dir.glob(Rails.root.join('app', 'models', 'concerns', 'fae', '**', '*.rb')).each do |f|
      #   require(f)
      # end

      ApplicationController.helper(ApplicationHelper)
    end

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
