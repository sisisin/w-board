class WakatimeRawUploader
  def initialize(target_date, options = {})
    @bucket = "raw-data-sisisin"
    @prefix = options.fetch(:prefix) { Time.now.strftime("%Y_%m_%d_%H_%M") }
    @target_date = target_date
    @s3 = Aws::S3::Client.new
    @summaries_file_name = "summaries-response.json"
  end

  def get_summaries_of_project_file_name(project_name)
    "summaries-of-#{project_name}-response.json"
  end

  def upload(summaries, project_details)
    put_to_s3(@summaries_file_name, summaries.to_json)
    project_details.each { |detail|
      project = detail.fetch(:project)
      body = detail.fetch(:body)
      put_to_s3(get_summaries_of_project_file_name(project.name), body.to_json)
    }

    meta = {
      :summaries => { key: "#{@prefix}/#{@summaries_file_name}", target_date: @target_date },
      :"project-summaries" => project_details.map { |detail|
        project = detail.fetch(:project)
        [project.name, {
          key: "#{@prefix}/#{get_summaries_of_project_file_name(project.name)}",
          target_date: @target_date,
          name: project.name,
        }]
      }.to_h,
    }
    put_to_s3("meta.json", meta.to_json)
  end

  private

  def put_to_s3(key, payload)
    Tempfile.create(key) do |f|
      f.puts(payload)
      f.close
      @s3.put_object(body: f, bucket: @bucket, key: "#{@prefix}/#{key}")
    end
  end
end
