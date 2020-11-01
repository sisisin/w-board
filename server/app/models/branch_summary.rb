# frozen_string_literal: true

class BranchSummary < ApplicationRecord
  belongs_to :branch

  def name
    branch.name
  end
end
