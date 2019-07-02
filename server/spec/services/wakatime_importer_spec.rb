RSpec.describe WakatimeImporter, type: :model do
  let(:project_details_mock) { JSON.load(File.open(File.join(Rails.root, "spec", "fixtures", "summaries_of_project.json"))) }
  let(:projects_mock) { JSON.load(File.open(File.join(Rails.root, "spec", "fixtures", "summaries.json"))) }
  let(:importer) do
    w = WakatimeImporter.new
    wakatime_client_doubel = double("wakatime_client", get_projects: projects_mock, get_project_details: project_details_mock)
    w.instance_variable_set("@w_client", wakatime_client_doubel)
    w
  end

  describe "save master data" do
    context "success normally" do
      before { importer.main }
    it "save to Project from API" do
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
        expect(klass.all.map(&:name)).to match_array project_details_mock["data"].first[prop].map { |p| p["name"] }
      end
    }
    end
    context "exists duplicate project" do
      before do
        FactoryBot.create(:project, name: projects_mock["data"].first["projects"][0]["name"])
        importer.main
      end

      it "has not error" do
        expect(Project.all.map(&:name)).to match_array projects_mock["data"].first["projects"].map { |p| p["name"] }
      end
    end
  end

  describe "#traverse" do
    let(:project_detail_map) { { '1': project_details_mock } }
    expected = {
      "1_master" => { "project_id" => :"1", "name" => "master", "total_seconds" => 25440.513085 },
      "1_Unknown" => { "project_id" => :"1", "name" => "Unknown", "total_seconds" => 380.54787 },
    }
    subject { importer.traverse(project_detail_map) }
    it "traverse wakatime response json" do
      expect(subject["branches"]).to match expected
    end
    it "contains master props" do
      expect(subject.keys).to contain_exactly("branches", "categories", "dependencies", "editors", "entities", "languages", "machines", "operating_systems")
    end
  end
end
