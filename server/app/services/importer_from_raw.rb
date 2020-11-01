class ImporterFromRaw
  def initialize
    @master_classes = [
        ["categories", Category],
        ["dependencies", Dependency],
        ["editors", Editor],
        ["languages", Language],
        ["machines", Machine],
        ["operating_systems", OperatingSystem]
    ]
    @master_classes_with_project = [
        ["branches", Branch],
        ["entities", Entity]
    ]
  end

  def import(target)
    project_names = target['summaries']["data"].first["projects"].map { |p| p["name"] }
    ps = project_names.map { |name| Project.new(name: name) }
    Project.import ps, ignore: true

    projects = Project.of_names(project_names)

    projects.each do |p|
      detail = target['by_details'][p.name]
      @master_classes.each { |key, klass|
        masters = detail['data'].first[key].map { |item| klass.new(name: item['name']) }
        klass.import! masters, ignore: true
      }
      @master_classes_with_project.each { |key,klass|
        masters = detail['data'].first[key].map { |item| klass.new(project: p, name: item['name']) }
        klass.import! masters, ignore: true
      }
    end
  end
end
