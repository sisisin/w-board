FactoryBot.define do
  factory :dependency_summary do
    dependency
    date { "2019-07-04" }
    total_seconds { 1.5 }
  end
end
