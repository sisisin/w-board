RSpec.describe WakatimeImporter, type: :model do
  let(:project_details_mock) { JSON.load(File.open(File.join(Rails.root, "spec", "fixtures", "summaries_of_project.json"))) }
  let(:projects_mock) { JSON.load(File.open(File.join(Rails.root, "spec", "fixtures", "summaries.json"))) }
  let(:raw_uploader_double) { double("raw_uploader", upload: nil) }
  let(:importer) do
    w = WakatimeImporter.new
    wakatime_client_double = double("wakatime_client", get_projects: projects_mock, get_project_details: project_details_mock)
    w.instance_variable_set("@w_client", wakatime_client_double)
    w.instance_variable_set("@raw_uploader", raw_uploader_double)
    w
  end

  describe "backup raw json" do
    before { importer.main }
    subject { raw_uploader_double }
    it "should call once" do
      expect(subject).to receive(:upload).once
      importer.main
    end
  end
  describe "save master data" do
    context "success normally" do
      before { importer.main }
      it "save to Project from API" do
        expect(Project.all.map(&:name)).to match_array projects_mock["data"].first["projects"].map { |p| p["name"] }
      end

      [
        ["branches", Branch],
        ["categories", Category],
        ["dependencies", Dependency],
        ["editors", Editor],
        ["entities", Entity],
        ["languages", Language],
        ["machines", Machine],
        ["operating_systems", OperatingSystem],
      ].each { |key, klass|
        it "save to #{klass.name} from API" do
          expect(klass.all.map(&:name)).to match_array project_details_mock["data"].first[key].map { |p| p["name"] }
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
    let(:project_detail_map) { [{ project: FactoryBot.build(:project, id: 1), body: project_details_mock }] }
    expected = {
      "1_master" => { "project_id" => 1, "name" => "master", "total_seconds" => 25440.513085 },
      "1_Unknown" => { "project_id" => 1, "name" => "Unknown", "total_seconds" => 380.54787 },
    }
    subject { importer.traverse(project_detail_map) }
    it "traverse wakatime response json" do
      expect(subject["branches"]).to match expected
    end
    it "contains master props" do
      expect(subject.keys).to contain_exactly("branches", "categories", "dependencies", "editors", "entities", "languages", "machines", "operating_systems")
    end
  end

  describe "save summary" do
    before { importer.main }

    def pick_values(key)
      project_details_mock["data"].first[key].map { |item| item.select { |k, _| ["name", "total_seconds"].include?(k) } }
    end

    [
      ["branches", BranchSummary],
      ["categories", CategorySummary],
      ["dependencies", DependencySummary],
      ["editors", EditorSummary],
      ["entities", EntitySummary],
      ["languages", LanguageSummary],
      ["machines", MachineSummary],
      ["operating_systems", OperatingSystemSummary],
    ].each { |key, klass|
      context "succeeds normally" do
        subject { klass.all.as_json(only: [:total_seconds], methods: [:name]) }
        it { is_expected.to match_array pick_values(key) }
      end
    }
  end
end
