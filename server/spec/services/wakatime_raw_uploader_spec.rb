require "rails_helper"

RSpec.describe WakatimeRawUploader, type: :model do
  describe "#upload", external_api: true do
    s3 = Aws::S3::Client.new
    bucket_name = "raw-data-sisisin"
    prefix = "__test"
    target_date = Date.new(2019, 7, 7)

    def delete_all_in_directory(s3, bucket_name, prefix)
      targets = s3.list_objects(bucket: bucket_name, prefix: prefix).contents.map { |c| { key: c.key } }
      s3.delete_objects(bucket: bucket_name, delete: { objects: targets }) if targets.present?
    end

    before :all do
      delete_all_in_directory(s3, bucket_name, prefix)
      WakatimeRawUploader.new(target_date, prefix: prefix)
        .upload(
          { summaries: 1 },
          [
            { project: FactoryBot.build(:project, name: "project_a"), body: { summaries_of_json: 2 } },
            { project: FactoryBot.build(:project, name: "project_b"), body: { summaries_of_json: 3 } },
          ]
        )
    end
    after :all do
      delete_all_in_directory(s3, bucket_name, prefix)
    end

    it "should upload summaries-response" do
      o = s3.get_object(bucket: bucket_name,
                        key: "#{prefix}/summaries-response.json")
      expect(JSON.load(o.body.read)).to match ({ "summaries" => 1 })
    end

    it "should upload summaries-" do
      o = s3.get_object(bucket: bucket_name,
                        key: "#{prefix}/summaries-of-project_a-response.json")
      expect(JSON.load(o.body.read)).to match ({ "summaries_of_json" => 2 })

      o2 = s3.get_object(bucket: bucket_name,
                         key: "#{prefix}/summaries-of-project_b-response.json")
      expect(JSON.load(o2.body.read)).to match ({ "summaries_of_json" => 3 })
    end

    it "should upload meta data" do
      o = s3.get_object(bucket: bucket_name,
                        key: "#{prefix}/meta.json")
      expect_hash = {
        "summaries" => { "key" => "#{prefix}/summaries-response.json", "target_date" => "2019-07-07" },
        "project-summaries" => {
          "project_a" => { "key" => "#{prefix}/summaries-of-project_a-response.json", "target_date" => "2019-07-07", "name" => "project_a" },
          "project_b" => { "key" => "#{prefix}/summaries-of-project_b-response.json", "target_date" => "2019-07-07", "name" => "project_b" },
        },
      }
      expect(JSON.load(o.body.read)).to match (expect_hash)
    end
  end
end
