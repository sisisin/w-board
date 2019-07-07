FactoryBot.define do
  factory :category_summary do
    category
    date { "2019-07-04" }
    total_seconds { 1.5 }
  end
end
