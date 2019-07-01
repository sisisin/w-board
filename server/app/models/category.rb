class Category < ApplicationRecord
  include HasName
  validates :name, uniqueness: true
end
