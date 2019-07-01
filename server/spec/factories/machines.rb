FactoryBot.define do
  factory :machine do
    sequence(:name) { |n| "machine#{n}" }
    sequence(:machine_name_id) { |n| "machine_name_id_#{n}" }
    project
  end
end
