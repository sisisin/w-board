class Language < ApplicationRecord
  validates :name, uniqueness: true
end
