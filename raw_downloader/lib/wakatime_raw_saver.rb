require_relative './wakatime_client'
require_relative './wakatime_raw_uploader'
require 'date'
require 'aws-sdk-s3'

class WakatimeRawSaver
  def initialize
    @target_date = Date.today -1
    @uploader = WakatimeRawUploader.new(@target_date)
    @w_client = WakatimeClient.new
  end

  def run
    puts "start process. target_date: #{@target_date}"

    project_summaries = @w_client.get_projects(@target_date)
    project_details = project_summaries["data"].first["projects"].map { |p|
      project_name = p['name']
      detail = @w_client.get_project_details(project_name, @target_date)
      [project_name, detail]
    }.to_h
    puts "got projects: #{project_details.keys.join(',')}"
    
    out = {
      parameters: { target_date: @target_date },
      summaries: project_summaries,
      by_details: project_details
    }
    @uploader.put_to_s3(out.to_json)

    puts "end process."
  end
end