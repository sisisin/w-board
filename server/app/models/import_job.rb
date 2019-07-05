class ImportJob < ApplicationRecord
  enum status: { waiting: "waiting", doing: "doing", succeeded: "succeeded", failed: "failed" }

  validates :target_date, presence: true
end
