class Branch < ApplicationRecord
  include HasName
  validates :name, uniqueness: true
end
