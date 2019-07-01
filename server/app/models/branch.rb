class Branch < ApplicationRecord
  validates :name, uniqueness: true
end
