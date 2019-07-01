class Language < ApplicationRecord
  include HasName
  validates :name, uniqueness: true
end
