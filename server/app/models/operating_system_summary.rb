class OperatingSystemSummary < ApplicationRecord
  belongs_to :operating_system

  def name
    operating_system.name
  end
end
