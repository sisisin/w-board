class Dependency < ApplicationRecord
  include HasName
  validates :name, uniqueness: true
end
