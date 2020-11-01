# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :branches, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :dependencies, dependent: :destroy
  has_many :editors, dependent: :destroy
  has_many :entities, dependent: :destroy
  has_many :languages, dependent: :destroy
  has_many :machines, dependent: :destroy
  has_many :operating_systems, dependent: :destroy

  validates :name, uniqueness: true

  scope :of_names, ->(names = []) {
                     if (safe_names = (names || []).reject(&:blank?)).present?
                       where(name: safe_names)
                     end
                   }
end
