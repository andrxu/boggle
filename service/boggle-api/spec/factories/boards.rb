FactoryBot.define do
  factory :Board do
    board_str { Faker::String.random(16) }
  end
end
