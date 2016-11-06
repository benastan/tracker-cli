module Tracker
  class Cli
    autoload :Command, 'tracker/cli/command'
    autoload :View, 'tracker/cli/view'
  
    def initialize(argv)
      validate_configuration!
      
      arguments = OptionParser.parse!(argv)
      arguments[:cli] = self
      
      case arguments[:method]
      when :list then Command::List.new(**arguments)
      when :fetch then Command::Fetch.new(**arguments)
      when :create then Command::Create.new(**arguments)
      when :destroy then Command::Destroy.new(**arguments)
      end
    end
    
    def connection
      @connection ||= Client.new(Tracker.api_token)
    end
    
    def validate_configuration!
      if Tracker.api_token.nil?
        error = "API Token missing. Find yours at https://www.pivotaltracker.com/profile and add: \n\napi_token: {{YOUR_TOKEN}}\n\n to ~/.tracker.config"
      end
      
      if Tracker.project.nil?
        error = "Project id is missing. Find the id in the url for the project and add: \n\nproject: {{YOUR_PROJECT_ID}}\n\n to ~/.tracker.config"
      end
      
      if error
        raise ArgumentError, error
      end
    end
  end
end