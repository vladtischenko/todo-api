# frozen_string_literal: true

FactoryGirl.define do
  factory :board do
    name { FFaker::Lorem.word }
    association :user
  end
end
