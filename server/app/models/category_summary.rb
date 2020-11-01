# frozen_string_literal: true

class CategorySummary < ApplicationRecord
  belongs_to :category

  def name
    category.name
  end
end
