require 'io/console'

namespace :fae do
  desc "Seeds the app with defaults and interactively created super admin"
  task :seed_db => :environment do
    super_admin_role = Fae::Role.create!(name: 'super admin', position: 0)
    Fae::Role.create!(name: 'admin', position: 1)
    Fae::Role.create!(name: 'user', position: 2)

    if Rails.env.in? %w[test development]
      super_admin_first_name = 'super_admin'
      super_admin_email =      'super_admin@example.com'
      super_admin_password =   'password'

      Fae::User.create!(
        role:       super_admin_role,
        first_name: super_admin_first_name,
        email:      super_admin_email,
        password:   super_admin_password
      )
      puts "\nDefault super_admin created - super_admin@example.com:password"
    else
      loop do
        puts "\nPlease enter super admin first_name:"
        super_admin_first_name = STDIN.readline

        puts '... and super admin email:'
        super_admin_email = STDIN.readline

        puts '... and super admin password:'
        super_admin_password = STDIN.getpass

        puts '... and confirm super admin password:'
        super_admin_password_confirmation = STDIN.getpass

        super_admin = Fae::User.create(
          role:                  super_admin_role,
          first_name:            super_admin_first_name,
          email:                 super_admin_email,
          password:              super_admin_password,
          password_confirmation: super_admin_password_confirmation
        )

        break if super_admin.valid?

        puts 'Invalid super admin data:'
        puts super_admin.errors.messages
      end
    end

    Fae::Option.create!(
      {
        title: 'admin panel',
        singleton_guard: 0,
        time_zone: 'UTC',
        live_url: 'https://www.example.com'
      }
    )
  end
end
