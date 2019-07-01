class Project < ApplicationRecord
  include HasName
  validates :name, uniqueness: true
end
