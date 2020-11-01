# frozen_string_literal: true

class MachineSummary < ApplicationRecord
  belongs_to :machine

  def name
    machine.name
  end
end
