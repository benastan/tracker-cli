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
          when 'memberships' then list_memberships
          when 'accounts'
            @objects = cli.connection.fetch(:accounts)
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
          @objects = cli.connection.fetch(:stories, projects: Tracker.project, query: query_params)
          @columns = -> (row) {
            [ row['id'], row['name'].to_json, row['current_state'], row['story_type'] ]
          }
        end
        
        def list_projects
          @objects = cli.connection.fetch(:projects)
          @columns = -> (row) {
            [ row['id'], row['name'].to_json ]
          }
        end
        
        def list_memberships
          @objects = cli.connection.fetch(:memberships, projects: Tracker.project)
          @columns = -> (row) {
            [ row['id'], row['person']['initials'], row['person']['name'].to_json ]
          }
        end
        
        def print_objects
          objects.each do |object|
            row = @columns.call(object)
    
            print row.join("\t")
            print "\n"
          end
        end
      end
    end
  end
end
