# frozen_string_literal: true

FactoryBot.define do
  factory :entity_summary do
    entity
    date { '2019-07-04' }
    total_seconds { 1.5 }
  end
end
