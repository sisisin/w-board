RSpec.describe WakatimeImporter, type: :model do
  let(:project_details_mock) { JSON.load(File.open(File.join(Rails.root, "spec", "fixtures", "summaries_of_project.json"))) }
  let(:projects_mock) { JSON.load(File.open(File.join(Rails.root, "spec", "fixtures", "summaries.json"))) }
  subject do
    w = WakatimeImporter.new
    wakatime_client_doubel = double("wakatime_client", get_projects: projects_mock, get_project_details: project_details_mock)
    w.instance_variable_set("@w_client", wakatime_client_doubel)
    w
  end

  describe "save master data" do
    it "save to Project from API" do
      subject.main
      expect(Project.all.map(&:name)).to match_array projects_mock["data"].first["projects"].map { |p| p["name"] }
    end

    [
      [Branch, "branches"],
      [Category, "categories"],
      [Dependency, "dependencies"],
      [Editor, "editors"],
      [Entity, "entities"],
      [Language, "languages"],
      [Machine, "machines"],
      [OperatingSystem, "operating_systems"],
    ].each { |klass, prop|
      it "save to #{klass.name} from API" do
        subject.main
        expect(klass.all.map(&:name)).to match_array project_details_mock["data"].first[prop].map { |p| p["name"] }
      end
    }

    context "exists duplicate project" do
      before do
        FactoryBot.create(:project, name: projects_mock["data"].first["projects"][0]["name"])
      end

      it "has not error" do
        subject.main
        expect(Project.all.map(&:name)).to match_array projects_mock["data"].first["projects"].map { |p| p["name"] }
      end
    end
  end
end
