class DependencySummary < ApplicationRecord
  belongs_to :dependency

  def name
    dependency.name
  end
end
