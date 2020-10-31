require "rails_helper"

RSpec.describe JobCreator, type: :model do
  describe "#run" do
    let(:job_creator) { JobCreator.new }

    context "create job normally" do
      before { job_creator.run }
      subject { ImportJob.all.map(&:status) }
      it { is_expected.to match_array ["waiting"] }
    end

    context "target date job already exists" do
      let(:target_date) { Date.yesterday }
      let!(:waiting_job) { FactoryBot.create(:import_job, status: :waiting, target_date: target_date) }
      before { job_creator.run(target_date) }
      subject { ImportJob.all.to_a }
      it { is_expected.to match_array [waiting_job] }
    end
  end

  describe "#run_with_date" do
    let(:target_date) { Date.yesterday }
    let(:job_creator) { JobCreator.new }
    context "create job normally" do
      before {
        FactoryBot.create(:import_job, status: :waiting, target_date: target_date)
        job_creator.run_with_date(target_date.strftime("%Y-%m-%d"))
      }
      subject { ImportJob.all.map(&:status) }
      it { is_expected.to match_array ["waiting", "waiting"] }
    end
  end
end
