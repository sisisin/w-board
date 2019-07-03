FactoryBot.define do
  factory :branch_summary do
    branch
    date { "2019-07-02" }
    total_seconds { 1.5 }
  end
end
