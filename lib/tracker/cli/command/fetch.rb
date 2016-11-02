module Tracker
  class Cli
    module Command
      class Fetch
        attr_reader :cli
        
        def initialize(cli: , object_type: , **arguments)
          @cli = cli
          
          case object_type
          when 'story' then fetch_story(**arguments)
          end
        end
        
        def fetch_story(object_id: nil, interactive: false, commit: false, **arguments)
          if object_id
            story = cli.connection.fetch_story(object_id)
          elsif interactive
            query_params = arguments.fetch(:query_params, {})
            stories = cli.connection.fetch_stories(project: Tracker.project, query: query_params)
            stories.each_with_index do |story, index|
              print "(#{index + 1}) #{story['id']} #{story['name'].to_json}\n"
            end
      
            print "\nWhich Story? "
            index = $stdin.gets.chomp.to_i - 1
            story = stories[index]
            print "\n"
          end
    
          if commit
            command = [
              :git, :commit,
              '-m', "\"[##{story['id']}] #{story['name'].to_json[1..-2]}\""
            ]
      
            stdin, stdout = Open3.popen2(command.join(' '))
            print stdout.read
          else
            print "#{story['id']}\t#{story['name'].to_json}\n"
          end
        end
      end
    end
  end
end
