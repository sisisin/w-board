# frozen_string_literal: true

FactoryBot.define do
  factory :operating_system_summary do
    operating_system
    date { '2019-07-04' }
    total_seconds { 1.5 }
  end
end
