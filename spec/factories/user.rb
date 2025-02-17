FactoryBot.define do
  factory :user do
    surname { Faker::Name.last_name }
    name { Faker::Name.first_name }
    patronymic { Faker::Name.middle_name }
    email { Faker::Internet.email }
    age { rand(18..65) }
    nationality { 'Русский' }
    country { 'Россия' }
    gender { %w[male female].sample }

    after(:build) do |user|
      user.interests << create(:interest, name: 'спорт')
      user.interests << create(:interest, name: 'музыка')

      user.skills << create(:skill, name: 'рукоделие')
      user.skills << create(:skill, name: 'коммуникации')
    end
  end
end