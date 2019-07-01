class Entity < ApplicationRecord
  include HasName
  validates :name, uniqueness: true
end
