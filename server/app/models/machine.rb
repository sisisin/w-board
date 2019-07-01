class Machine < ApplicationRecord
  validates :name, uniqueness: true
end
