module Tracker
  class Cli
    module Command
      class Create
        attr_reader :cli, :arguments
        
        def initialize(cli: , object_type: , query_params: {}, **arguments)
          @cli = cli
          @arguments = arguments
          @params = query_params.dup
         
          setup_create(object_type, **arguments)
          print cli.connection.post(@path, URI.encode_www_form(@params)).body.to_json
        end
        
        def setup_create(object_type, interactive: false, **arguments)
          case object_type
          when 'project'
            @params.merge!(
              name: View::Input.new('Name').value,
              no_owner: View::Input.new('No owner', type: :boolean).value
            ) if interactive

            @path = 'projects'

          when 'story'
            @params.merge!({
              name: View::Input.new('Name').value,
              story_type: View::Select.new('What type of story is this?', [ :feature, :bug, :chore, :release ]).selection
            }) if interactive
            
            @path = "projects/#{Tracker.project}/stories"
            
          end
        end

      end
    end
  end
end
