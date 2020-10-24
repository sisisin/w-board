require_relative './wakatime_raw_saver'

def handler(event:,context:)
  puts "start event"
  puts({event: event, context: context}.to_json)
  WakatimeRawSaver.new.run
end
