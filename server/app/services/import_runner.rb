# frozen_string_literal: true

class ImportRunner
  def initialize(storage_mode: :local)
    @storage_mode = storage_mode
  end

  def run
    ImporterFromRaw.new.import target_from_storage
  end

  def target_from_storage
    key = '2020-10-18/2020_10_25_20_16_00_658_summaries.json'
    tmp_path = Rails.root.join('tmp', 'raw', key)

    case @storage_mode
    when :local
      # todo
    when :s3
      s3 = Aws::S3::Client.new

      FileUtils.mkdir_p(File.dirname(tmp_path))
      f = File.open(tmp_path, 'w')
      s3.get_object(bucket: 'wakatime-raw', key: key, response_target: f.path)

      f.close

    else
      raise "Unknown storage_mode: #{@storage_mode}"
    end

    JSON.parse(File.open(tmp_path, 'r').read.to_str)
  end
end
