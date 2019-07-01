require "rails_helper"

RSpec.describe Project, type: :model do
  describe "validate name" do
    before do
      FactoryBot.create(:project, name: "name!")
    end
    subject { FactoryBot.build(:project, name: "name!") }
    it "should be invalid that duplicate name" do
      expect(subject.valid?).to be false
    end
  end

  describe ".of_names" do
    let!(:projects) { FactoryBot.create_list(:project, 2) }

    context "specify arguments" do
      subject { Project.of_names([projects[0].name]).map(&:name) }

      it { is_expected.to match_array projects.map(&:name)[0..0] }
    end
    context "empty arguments" do
      subject { Project.of_names(nil).map(&:name) }

      it { is_expected.to match_array projects.map(&:name) }
    end
  end
end
