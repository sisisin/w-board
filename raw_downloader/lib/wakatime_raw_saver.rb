require_relative './wakatime_client'
require_relative './wakatime_raw_uploader'
require 'date'
require 'aws-sdk-s3'
require 'twitter'

class WakatimeRawSaver
  def initialize(target_date = Date.today - 1)
    @target_date = target_date
    @uploader = WakatimeRawUploader.new
    @w_client = WakatimeClient.new
    @tw_client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV.fetch 'TW_CONSUMER_KEY'
      config.consumer_secret     = ENV.fetch 'TW_CONSUMER_SECRET'
      config.access_token        = ENV.fetch 'TW_ACCESS_TOKEN'
      config.access_token_secret = ENV.fetch 'TW_ACCESS_TOKEN_SECRET'
    end
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
    
    downloaded_at = DateTime.now
    out = {
      meta: { downloaded_at: downloaded_at },
      parameters: { target_date: @target_date },
      summaries: project_summaries,
      by_details: project_details
    }
    @uploader.put_to_s3(out)

    puts "end process."
    msg_header = "@Azsimeji [w-board] dl completed."
    total = "#{project_summaries["data"].first["grand_total"]["text"]} on #{@target_date}."
    meta = "downloaded_at: #{out[:meta][:downloaded_at]}."
    @tw_client.update("#{msg_header} #{total} #{meta}")
  end
end