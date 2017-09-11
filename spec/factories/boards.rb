FactoryGirl.define do
  factory :board do
    name { FFaker::Lorem.word }
    association :user
  end
end
