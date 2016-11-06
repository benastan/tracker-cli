module Tracker
  class Cli
    module View
      class Input
        attr_reader :value
        
        def initialize(attribute_name, type: nil)
          type ||= :string
          
          loop do
            $stderr.print "#{attribute_name}#{' (y/n)' if type == :boolean}? "
            value = $stdin.gets.chomp
            $stderr.print "\n"
            
            if type == :string
              if value == ''
                $stderr.print "Cannot be blank.\n"
              else
                @value = value
              end
              
            elsif type == :boolean
              if value == 'y' || value == 'n'
                @value = value == 'y'
              else
                $stderr.print "Please provide either \"y\" or \"n\"\n"
              end
            end
            
            break unless @value.nil?
          end
        end
      end
    end
  end
end
