FactoryBot.define do
  factory :machine_summary do
    machine
    date { "2019-07-04" }
    total_seconds { 1.5 }
  end
end
