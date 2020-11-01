# frozen_string_literal: true

FactoryBot.define do
  factory :editor_summary do
    editor
    date { '2019-07-04' }
    total_seconds { 1.5 }
  end
end
