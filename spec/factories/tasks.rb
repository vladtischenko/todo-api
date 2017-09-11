FactoryGirl.define do
  factory :task do
    status :pending
    name { FFaker::Lorem.words.join(' ') }
    description { FFaker::Lorem.sentence }
    association :board
  end
end
