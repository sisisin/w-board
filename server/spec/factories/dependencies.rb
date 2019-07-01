FactoryBot.define do
  factory :dependency do
    sequence(:name) { |n| "dependency#{n}" }
    project
  end
end
