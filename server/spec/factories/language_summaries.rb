FactoryBot.define do
  factory :language_summary do
    language
    date { "2019-07-04" }
    total_seconds { 1.5 }
  end
end
