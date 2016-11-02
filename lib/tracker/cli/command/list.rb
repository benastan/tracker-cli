module Tracker
  class Cli
    module Command
      class List
        attr_reader :cli, :arguments, :objects, :columns
        
        def initialize(cli: , object_type: , **arguments)
          @cli = cli
          @arguments = arguments
          
          case object_type
          when 'stories' then list_stories
          when 'projects' then list_projects
          end
    
          case arguments[:format_name]
          when 'json'
            print JSON.dump(objects)
          else
            print_objects
          end
        end
        
        def list_stories
          query_params = arguments.fetch(:query_params, {})
          @objects = cli.connection.fetch_stories(project: Tracker.project, query: query_params)
          @columns = [ 'id', 'name', 'current_state', 'story_type' ]
        end
        
        def list_projects
          @objects = cli.connection.get('projects').body
          @columns = [ 'id', 'name' ]
        end
        
        def print_objects
          objects.each do |object|
            row = object.map do |(k, v)|
              if columns.include?(k)
                k == 'name' ? v.to_json : v
              end
            end.compact
    
            print row.join("\t")
            print "\n"
          end
        end
      end
    end
  end
end
