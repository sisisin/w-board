class Entity < ApplicationRecord
  validates :name, uniqueness: true
end
