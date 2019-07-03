class CategorySummary < ApplicationRecord
  belongs_to :category

  def name
    category.name
  end
end
