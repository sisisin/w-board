class WakatimeRawUploader
  def initialize(target_date, options = {})
    @bucket = "wakatime-raw"
    @prefix = options.fetch(:prefix) { Time.now.strftime("%Y_%m_%d_%H_%M") }
    @s3 = Aws::S3::Client.new
  end

  def put_to_s3(payload)
    key = 'summaries.json'
    Tempfile.create(key) do |f|
      f.puts(payload)
      f.close
      @s3.put_object(body: f, bucket: @bucket, key: "#{@prefix}_#{key}")
    end
  end
end
