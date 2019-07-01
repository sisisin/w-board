class Dependency < ApplicationRecord
  validates :name, uniqueness: true
end
