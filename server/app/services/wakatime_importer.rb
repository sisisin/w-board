class WakatimeImporter
  def initialize
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

  def main(target_date = Date.yesterday)
    Rails.logger.info "start import from #{target_date}"
    project_names = @w_client.get_projects(target_date)["data"].first["projects"].map { |p| p["name"] }
    Project.import project_names.map { |name| Project.new(name: name) }, ignore: true

    target_projects = Project.of_names(project_names)
    project_detail_map = target_projects.map { |p| [p.id, @w_client.get_project_details(p.name, target_date)] }.to_h

    traversed = traverse(project_detail_map)
    bulk_insert_masters(traversed)

    master_map = get_master_map(traversed)
    bulk_insert_details(target_date, traversed, master_map)
  end

=begin
{
  branches: {1_master => {project_id=>1, name=> 'master', total_seconds=>1234}},
  categories: ...
}
=end
  def traverse(project_detail_map)
    @master_classes.map { |key, _|
      value = project_detail_map.flat_map { |project_id, detail|
        detail["data"].first[key].map { |item|
          [
            "#{project_id}_#{item["name"]}",
            { "project_id" => project_id, "name" => item["name"], "total_seconds" => item["total_seconds"] },
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

  def bulk_insert_details(target_date, traversed, master_map)
    # todo: bin/rails g model branch_summary branch:references date:date total_seconds:decimal{20,6}
    [["branches", BranchSummary]].each { |key, klass|
      summaries = traversed[key].map { |_, detail|
        klass.new(
          branch_id: master_map[key].fetch("#{detail["project_id"]}_#{detail["name"]}").id,
          date: target_date,
          total_seconds: detail["total_seconds"],
        )
      }
      klass.import summaries, ignore: false
    }
  end
end