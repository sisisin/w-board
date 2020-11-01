# frozen_string_literal: true

desc "Alias for `rake import:run`"
task :import => ["import:run"]

namespace :import do
  desc "Import from wakatime"
  task run: :environment do
    WakatimeImporter.new.main
  end

  desc 'import from raw'
  task from_raw: :environment do
    ImportRunner.new.run
  end
end
