FactoryBot.define do
  factory :branch do
    sequence(:name) { |n| "branch#{n}" }
    project
  end
end
