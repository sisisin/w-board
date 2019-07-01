class OperatingSystem < ApplicationRecord
  include HasName
  validates :name, uniqueness: true
end
