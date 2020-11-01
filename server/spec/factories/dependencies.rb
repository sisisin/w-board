# frozen_string_literal: true

FactoryBot.define do
  factory :dependency do
    sequence(:name) { |n| "dependency#{n}" }
    project
  end
end
