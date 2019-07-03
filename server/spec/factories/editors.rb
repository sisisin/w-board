FactoryBot.define do
  factory :editor do
    sequence(:name) { |n| "editor#{n}" }
    project
  end
end
