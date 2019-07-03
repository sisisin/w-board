class EntitySummary < ApplicationRecord
  belongs_to :entity

  def name
    entity.name
  end
end
