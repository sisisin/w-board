FactoryBot.define do
  factory :language do
    sequence(:name) { |n| "language#{n}" }
    project
  end
end
