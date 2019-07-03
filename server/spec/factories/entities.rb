FactoryBot.define do
  factory :entity do
    sequence(:name) { |n| "entity#{n}" }
    project
  end
end
