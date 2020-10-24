require 'httpclient'
require 'json'

class WakatimeClient
  def initialize
    @api_key = ENV.fetch('WAKATIME_API_KEY')
    @client = HTTPClient.new
    @base_url = 'https://wakatime.com/api/v1/users/52f058ec-e04e-436b-906d-eff6c461abf5/summaries'
  end

  def get_projects(target_date = Date.yesterday)
    body = @client.get(@base_url, api_key: @api_key, start: target_date.to_s, end: target_date.to_s).body
    JSON.load(body)
  end

  def get_project_details(project_name, target_date = Date.yesterday)
    body = @client.get(@base_url, api_key: @api_key, start: target_date.to_s, end: target_date.to_s, project: project_name).body
    JSON.load(body)
  end
end
