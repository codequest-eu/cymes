namespace :fae do
  desc "Seeds the parent app with Fae's defaults"
  task :seed_db => :environment do
    if Fae::Role.first.blank?
      Fae::Role.create(name: 'super admin', position: 0)
      Fae::Role.create(name: 'admin', position: 1)
      Fae::Role.create(name: 'user', position: 2)
    end

    if Fae::Option.first.blank?
      option = Fae::Option.new({
        title: 'admin panel',
        singleton_guard: 0,
        time_zone: 'Pacific Time (US & Canada)',
        live_url: 'https://www.example.com'
        })
      option.save!
    end
  end
end
