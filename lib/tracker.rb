require 'psych'

module Tracker
  autoload :Cli, 'tracker/cli'
  autoload :Client, 'tracker/client'
  autoload :OptionParser, 'tracker/option_parser'
  
  def self.api_token
    config['api_token']
  end

  def self.project
    config['project']
  end
  
  def self.config
    if File.exist?(configuration_file_location)
      content = File.read(configuration_file_location)
      Psych.load(content)
    else
      {}
    end
  end
  
  def self.configuration_file_location
    @configuration_file_location ||= Pathname(ENV['HOME']).join('.tracker.config').to_s
  end
end
