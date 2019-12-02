FactoryGirl.define do

  factory :fae_option, class: 'Fae::Option' do
    title 'admin panel'
    singleton_guard 0
    time_zone 'Pacific Time (US & Canada)'
    live_url 'http://google.com'
  end

end
