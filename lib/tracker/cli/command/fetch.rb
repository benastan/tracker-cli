module Tracker
  class Cli
    module Command
      class Fetch
        attr_reader :cli, :arguments
        
        def initialize(cli: , object_type: , **arguments)
          @cli = cli
          @arguments = arguments
          
          case object_type
          when 'story' then fetch_story(**arguments)
          end
        end
        
        def fetch_story(object_id: nil, interactive: false, commit: false, **arguments)
          if object_id
            story = cli.connection.fetch(stories: object_id)
          elsif interactive
            story = select_story
          end
    
          if commit
            create_commit(story)
          else
            print "#{story['id']}\t#{story['name'].to_json}\n"
          end
        end
        
        def select_story
          query_params = arguments.fetch(:query_params, {})
          stories = cli.connection.fetch(:stories, projects: Tracker.project, query: query_params)
          stories.each_with_index do |story, index|
            print "(#{index + 1}) #{story['id']} #{story['name'].to_json}\n"
          end
  
          print "\nWhich Story? "
          index = $stdin.gets.chomp.to_i - 1
          print "\n"
          stories[index]
        end
        
        def create_commit(story)
          commit_message = "\"[##{story['id']}] #{story['name'].to_json[1..-2]}\""
          command = [ 'git', 'commit', '-m', commit_message ]
          _, stdout = Open3.popen2(*command)
          print stdout.read
        end
      end
    end
  end
end
