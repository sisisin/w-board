require "rails_helper"

RSpec.describe ImportJob, type: :model do
  describe "validates" do
    context "no target_date" do
      subject { FactoryBot.build(:import_job, target_date: nil).valid? }
      it { is_expected.to be false }
    end
  end
end
