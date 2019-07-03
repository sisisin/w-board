FactoryBot.define do
  factory :operating_system do
    sequence(:name) { |n| "operating_system#{n}" }
    project
  end
end
