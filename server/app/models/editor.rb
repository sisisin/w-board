class Editor < ApplicationRecord
  include HasName
  validates :name, uniqueness: true
end
