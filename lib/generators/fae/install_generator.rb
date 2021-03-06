module Fae
  class InstallGenerator < Rails::Generators::Base
    source_root ::File.expand_path('../templates', __FILE__)
    class_option :namespace, type: :string, default: 'admin', desc: 'Sets the namespace of the generator'

    def install
      run 'bundle install'
      add_route
      # copy templates and generators
      copy_file ::File.expand_path(::File.join(__FILE__, "../templates/tasks/fae_tasks.rake")), "lib/tasks/fae_tasks.rake"
      disable_api_only_mode
      add_fae_assets
      add_navigation_concern
      add_authorization_concern
      build_initializer
      build_judge_initializer
      rake 'fae:install:migrations'
      rake 'db:migrate'
      rake 'fae:seed_db'
    end

  private

    def add_route
      inject_into_file "config/routes.rb", after: "routes.draw do\n" do <<-RUBY
  constraints subdomain: /^#{options.namespace}/ do
    scope module: '#{options.namespace}', as: '#{options.namespace}' do
    end
    mount Fae::Engine => '/'
  end\n
RUBY
      end
    end

    def add_fae_assets
      copy_file ::File.expand_path(::File.join(__FILE__, '../templates/assets/fae.scss')), 'app/assets/stylesheets/fae.scss'
      copy_file ::File.expand_path(::File.join(__FILE__, '../templates/assets/fae.js')), 'app/assets/javascripts/fae.js'
      copy_file ::File.expand_path(::File.join(__FILE__, '../templates/assets/config/manifest.js')), 'app/assets/config/manifest.js'
    end

    def add_navigation_concern
      copy_file ::File.expand_path(::File.join(__FILE__, '../templates/models/concerns/navigation_concern.rb')), 'app/models/concerns/fae/navigation_concern.rb'
    end

    def add_authorization_concern
      copy_file ::File.expand_path(::File.join(__FILE__, '../templates/models/concerns/authorization_concern.rb')), 'app/models/concerns/fae/authorization_concern.rb'
    end

    def build_initializer
      copy_file ::File.expand_path(::File.join(__FILE__, "../templates/initializers/fae.rb")), "config/initializers/fae.rb"
    end

    def build_judge_initializer
      copy_file ::File.expand_path(::File.join(__FILE__, "../templates/initializers/judge.rb")), "config/initializers/judge.rb"
    end

    def disable_api_only_mode
      gsub_file(
        'config/application.rb',
        /config.api_only\s*=\s*true/,
        'config.api_only = false'
      )

      gsub_file(
        'config/application.rb',
        /#\s*require "sprockets\/railtie"/,
        'require "sprockets/railtie"'
      )
    end
  end
end
