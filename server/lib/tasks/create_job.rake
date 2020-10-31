# frozen_string_literal: true

desc "Alias for `rake create_job:run`"
task :create_job => ["create_job:run"]

namespace :create_job do
  desc "Create import job"
  task run: :environment do
    JobCreator.new.run
  end

  desc "Create import job specified date through ARGV"
  task with_date: :environment do
    JobCreator.new.run_with_date(ARGV[1])

    ARGV.select
      .with_index { |_, i| i > 0 }
      .each { |v| task v.to_sym do; end }
  end
end
