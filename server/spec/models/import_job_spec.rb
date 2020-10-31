require "rails_helper"

RSpec.describe ImportJob, type: :model do
  describe "validates" do
    context "no target_date" do
      subject { FactoryBot.build(:import_job, target_date: nil).valid? }
      it { is_expected.to be false }
    end
  end

  describe ".find_job_to_run" do
    context "exists job to run" do
      let!(:import_jobs) {
        [
          FactoryBot.create(:import_job, status: :succeeded),
          FactoryBot.create(:import_job, status: :waiting),
          FactoryBot.create(:import_job, status: :waiting),
        ]
      }
      subject { ImportJob.find_job_to_run }
      it { is_expected.to eq import_jobs[1] }
    end

    context "NOT exists job to run" do
      let!(:import_jobs) {
        [
          FactoryBot.create(:import_job, status: :succeeded),
        ]
      }
      subject { ImportJob.find_job_to_run }
      it { is_expected.to eq nil }
    end
  end
end
