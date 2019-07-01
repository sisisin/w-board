require "rails_helper"

RSpec.describe Branch, type: :model do
  describe "validate" do
    let(:project) { FactoryBot.create(:project) }
    let(:branch) { FactoryBot.create(:branch, name: "develop", project: project) }

    context "duplicate branch name and project ref" do
      subject { Branch.new(name: branch.name, project_id: branch.project_id).valid? }
      it { is_expected.to be false }
    end
  end

  describe ".of_project_and_names" do
    let(:projects) { FactoryBot.create_list(:project, 2) }
    let!(:branches) {
      [
        FactoryBot.create(:branch, project: projects[0], name: "master"),
        FactoryBot.create(:branch, project: projects[0], name: "develop"),
        FactoryBot.create(:branch, project: projects[1], name: "master"),
      ]
    }

    context "specify project_id and names" do
      subject(:one_name) { Branch.of_project_and_names(branches[0].project_id, branches.map(&:name)[0..0]).map(&:name) }
      it "should return master" do
        expect(one_name).to match_array branches.map(&:name)[0..0]
      end

      subject(:two_names) { Branch.of_project_and_names(branches[0].project_id, branches.map(&:name)[0..1]).map(&:name) }
      it "should return master and develop" do
        expect(two_names).to match_array branches.map(&:name)[0..1]
      end
    end
  end
end
