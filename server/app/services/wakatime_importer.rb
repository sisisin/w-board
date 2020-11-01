# frozen_string_literal: true

class WakatimeImporter
  def initialize(target_date = Date.yesterday)
    @target_date = target_date
    @raw_uploader = WakatimeRawUploader.new(target_date)
    @w_client = WakatimeClient.new
    @master_classes = [
      ['branches', Branch],
      ['categories', Category],
      ['dependencies', Dependency],
      ['editors', Editor],
      ['entities', Entity],
      ['languages', Language],
      ['machines', Machine],
      ['operating_systems', OperatingSystem]
    ]
  end

  def main
    Rails.logger.info "start import from #{@target_date}"
    project_summaries = @w_client.get_projects(@target_date)
    project_names = project_summaries['data'].first['projects'].map { |p| p['name'] }
    Project.import project_names.map { |name| Project.new(name: name) }, ignore: true

    target_projects = Project.of_names(project_names)
    project_details = target_projects.map do |p|
      { project: p, body: @w_client.get_project_details(p.name, @target_date) }
    end

    backup_raws(project_summaries, project_details)

    traversed = traverse(project_details)
    bulk_insert_masters(traversed)

    bulk_insert_details(traversed)
  end

  def backup_raws(project_summaries, project_details)
    @raw_uploader.upload(project_summaries, project_details)
  end

  # {
  #   branches: {1_master => {project_id=>1, name=> 'master', total_seconds=>1234}},
  #   categories: ...
  # }
  def traverse(project_detail_map)
    @master_classes.map do |key, _|
      value = project_detail_map.flat_map do |detail|
        p = detail.fetch(:project)
        body = detail.fetch(:body)
        body['data'].first[key].map do |item|
          [
            "#{p.id}_#{item['name']}",
            { 'project_id' => p.id, 'name' => item['name'], 'total_seconds' => item['total_seconds'] }
          ]
        end
      end.to_h
      [key, value]
    end.to_h
  end

  def get_master_map(traversed)
    @master_classes.map do |key, klass|
      value = klass
              .of_names(traversed[key].to_a.map { |_, item| item['name'] })
              .index_by { |b| "#{b.project_id}_#{b.name}" }
      [key, value]
    end.to_h
  end

  def bulk_insert_masters(traversed)
    @master_classes.each do |key, klass|
      masters = traversed[key].map do |_, item|
        klass.new(project_id: item['project_id'], name: item['name'])
      end
      klass.import masters, ignore: true
    end
  end

  def bulk_insert_details(traversed)
    master_map = get_master_map(traversed)

    [
      ['branches', BranchSummary, :branch_id],
      ['categories', CategorySummary, :category_id],
      ['dependencies', DependencySummary, :dependency_id],
      ['editors', EditorSummary, :editor_id],
      ['entities', EntitySummary, :entity_id],
      ['languages', LanguageSummary, :language_id],
      ['machines', MachineSummary, :machine_id],
      ['operating_systems', OperatingSystemSummary, :operating_system_id]
    ].each do |key, klass, ref|
      summaries = traversed[key].map do |_, detail|
        params = [
          [ref, master_map[key].fetch("#{detail['project_id']}_#{detail['name']}").id],
          [:date, @target_date],
          [:total_seconds, detail['total_seconds']]
        ].to_h
        klass.new(params)
      end
      klass.import summaries, ignore: true
    end
  end
end
