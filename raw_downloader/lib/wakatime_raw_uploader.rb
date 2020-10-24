class WakatimeRawUploader
  def initialize
    @bucket = "wakatime-raw"
    @s3 = Aws::S3::Client.new
  end

  def put_to_s3(payload)
    key = 'summaries.json'
    prefix = payload[:meta][:downloaded_at].strftime('%Y_%m_%d_%H_%M_%S_%L')
    Tempfile.create(key) do |f|
      f.puts(payload.to_json)
      f.close
      @s3.put_object(body: f, bucket: @bucket, key: "#{prefix}_#{key}")
    end
  end
end
