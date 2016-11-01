module Tracker
  class Cli
    def initialize(argv)
      validate_configuration!
      
      arguments = OptionParser.parse!(argv)
      
      send(arguments[:method], **arguments)
    end
    
    def list(object_type: , **arguments)
      case object_type
      when 'stories'
        stories = connection.fetch_stories(project: Tracker.project)
        case arguments[:format_name]
        when 'json'
          print JSON.dump(stories)
        else
          stories.each do |story|
            print [ story['id'], story['name'].to_json, story['current_state'], story['story_type'] ].join("\t")
            print "\n"
          end
        end
      end
    end
    
    def fetch(object_type: , object_id: nil, interactive: false, **arguments)
      case object_type
      when 'story'
        if object_id
          story = connection.fetch_story(object_id)
        elsif interactive
          stories = connection.fetch_stories(project: Tracker.project)
          stories.each_with_index do |story, index|
            print "(#{index + 1}) #{story['id']} #{story['name'].to_json}\n"
          end
          
          print "\nWhich Story? "
          index = $stdin.gets.chomp.to_i - 1
          story = stories[index]
          print "\n"
        end

        print "#{story['id']}\t#{story['name'].to_json}\n"
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