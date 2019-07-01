class WakatimeImporter
  def initialize
    @w_client = WakatimeClient.new
  end

  def main
    project_names = @w_client.get_projects["data"].first["projects"].map { |p| p["name"] }
    Project.import project_names.map { |name| Project.new(name: name) }, ignore: true

    project_by_name_map = Project.of_names(project_names).map { |p| [p.name, p] }.to_h

    project_names.each { |name|
      project_details = @w_client.get_project_details(name)
      bulk_insert_masters(project_by_name_map.fetch(name), project_details)
    }
  end

  def bulk_insert_masters(target_project, project_details)
    data = project_details["data"].first
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
      klass.import data[prop].map { |c| klass.new(project_id: target_project.id, name: c["name"]) }, ignore: true
    }
  end
end
