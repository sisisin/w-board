FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "category#{n}" }
    project
  end
end
