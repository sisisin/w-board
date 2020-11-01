# frozen_string_literal: true

class EntitySummary < ApplicationRecord
  belongs_to :entity

  def name
    entity.name
  end
end
