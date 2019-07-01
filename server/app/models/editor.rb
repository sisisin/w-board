class Editor < ApplicationRecord
  validates :name, uniqueness: true
end
