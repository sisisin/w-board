class WakatimeImporter
  def initialize(target_date = Date.yesterday)
    @target_date = target_date
    @raw_uploader = WakatimeRawUploader.new(target_date)
    @w_client = WakatimeClient.new
    @master_classes = [
      ["branches", Branch],
      ["categories", Category],
      ["dependencies", Dependency],
      ["editors", Editor],
      ["entities", Entity],
      ["languages", Language],
      ["machines", Machine],
      ["operating_systems", OperatingSystem],
    ]
  end

  def main
    Rails.logger.info "start import from #{@target_date}"
    project_summaries = @w_client.get_projects(@target_date)
    project_names = project_summaries["data"].first["projects"].map { |p| p["name"] }
    Project.import project_names.map { |name| Project.new(name: name) }, ignore: true

    target_projects = Project.of_names(project_names)
    project_details = target_projects.map { |p|
      { project: p, body: @w_client.get_project_details(p.name, @target_date) }
    }

    traversed = traverse(project_details)
    bulk_insert_masters(traversed)

    bulk_insert_details(traversed)
  end

=begin
{
  branches: {1_master => {project_id=>1, name=> 'master', total_seconds=>1234}},
  categories: ...
}
=end
  def traverse(project_detail_map)
    @master_classes.map { |key, _|
      value = project_detail_map.flat_map { |detail|
        p = detail.fetch(:project)
        body = detail.fetch(:body)
        body["data"].first[key].map { |item|
          [
            "#{p.id}_#{item["name"]}",
            { "project_id" => p.id, "name" => item["name"], "total_seconds" => item["total_seconds"] },
          ]
        }
      }.to_h
      [key, value]
    }.to_h
  end

  def get_master_map(traversed)
    @master_classes.map { |key, klass|
      value = klass
        .of_names(traversed[key].to_a.map { |_, item| item["name"] })
        .map { |b| ["#{b.project_id}_#{b.name}", b] }.to_h
      [key, value]
    }.to_h
  end

  def bulk_insert_masters(traversed)
    @master_classes.each { |key, klass|
      masters = traversed[key].map { |_, item|
        klass.new(project_id: item["project_id"], name: item["name"])
      }
      klass.import masters, ignore: true
    }
  end

  def bulk_insert_details(traversed)
    master_map = get_master_map(traversed)

    [
      ["branches", BranchSummary, :branch_id],
      ["categories", CategorySummary, :category_id],
      ["dependencies", DependencySummary, :dependency_id],
      ["editors", EditorSummary, :editor_id],
      ["entities", EntitySummary, :entity_id],
      ["languages", LanguageSummary, :language_id],
      ["machines", MachineSummary, :machine_id],
      ["operating_systems", OperatingSystemSummary, :operating_system_id],
    ].each { |key, klass, ref|
      summaries = traversed[key].map { |_, detail|
        params = [
          [ref, master_map[key].fetch("#{detail["project_id"]}_#{detail["name"]}").id],
          [:date, @target_date],
          [:total_seconds, detail["total_seconds"]],
        ].to_h
        klass.new(params)
      }
      klass.import summaries, ignore: true
    }
  end
end
