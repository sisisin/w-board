# frozen_string_literal: true

FactoryBot.define do
  factory :entity do
    sequence(:name) { |n| "entity#{n}" }
    project
  end
end
