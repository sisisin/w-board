# frozen_string_literal: true

FactoryBot.define do
  factory :editor do
    sequence(:name) { |n| "editor#{n}" }
    project
  end
end
