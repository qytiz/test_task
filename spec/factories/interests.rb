FactoryBot.define do
  factory :interest do
    name { Faker::Hobby.activity }
  end
end