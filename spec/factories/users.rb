# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    name { FFaker::Name.name }
    provider 'email'
    uid { email }
    timezone { TZInfo::Timezone.all_data_zone_identifiers.sample }
  end
end
