module Tracker
  class Cli
    module Command
      class Create
        attr_reader :cli, :arguments
        
        def initialize(cli: , object_type: , **arguments)
          @cli = cli
          @arguments = arguments
          
          case object_type
          when 'project' then create_project(**arguments)
          end
        end
        
        def create_project(query_params: {}, **arguments)
          print cli.connection.post('projects', URI.encode_www_form(query_params)).body.to_json
        end
      end
    end
  end
end
