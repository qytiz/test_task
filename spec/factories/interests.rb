# frozen_string_literal: true

FactoryBot.define do
  factory :interest do
    name { Faker::Hobby.activity }
  end
end
