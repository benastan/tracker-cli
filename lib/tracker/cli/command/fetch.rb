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
          when 'account'
            print cli.connection.fetch(accounts: object_id)
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
            print "#{story['name']} (#{story['kind']} ##{story['id']})\n\n"
            print "#{story['labels'].join(', ')}\n\n" if story['labels'].any?
            print "#{story['description'] || '(no description)'}\n\n"
            print "#{story['url']}\n"
          end
        end
        
        def select_story
          query_params = arguments.fetch(:query_params, {})
          stories = cli.connection.fetch(:stories, projects: Tracker.project, query: query_params)
          
          select = View::Select.new('Which Story?', stories) { |story| "#{story['id']} #{story['name'].to_json}" }
          select.selection
        end
        
        def create_commit(story)
          commit_message = "[##{story['id']}] #{story['name'].to_json[1..-2]}"
          command = [ 'git', 'commit', '-m', commit_message ]
          _, stdout = Open3.popen2(*command)
          $stderr.print stdout.read
        end
      end
    end
  end
end
