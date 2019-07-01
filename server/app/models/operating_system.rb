class OperatingSystem < ApplicationRecord
  validates :name, uniqueness: true
end
