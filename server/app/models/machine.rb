class Machine < ApplicationRecord
  include HasName
  validates :name, uniqueness: true
end
