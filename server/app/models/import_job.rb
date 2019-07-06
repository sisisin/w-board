class ImportJob < ApplicationRecord
  enum status: { waiting: "waiting", doing: "doing", succeeded: "succeeded", failed: "failed" }

  validates :target_date, presence: true

  class << self
    def find_job_to_run(import_job = all)
      import_job.find_by(status: :waiting)
    end
  end
end
