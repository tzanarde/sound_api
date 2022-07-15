require 'factory_bot_rails'
require 'pry'

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  Dir['./spec/support/**/*.rb'].sort.each { |f| require f }
end
