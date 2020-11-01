# frozen_string_literal: true

namespace :docker do
  desc 'Build docker image'
  task build: :environment do
    `docker build . -t sisisin/w-board:$(git rev-parse --short=10 HEAD)`
    puts 'build completed.'
  end

  task push: :environment do
    `docker build . -t sisisin/w-board:$(git rev-parse --short=10 HEAD)`
    `docker push sisisin/w-board:$(git rev-parse --short=10 HEAD)`
    puts 'push completed.'
  end
end
