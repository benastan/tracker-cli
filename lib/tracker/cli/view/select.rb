module Tracker
  class Cli
    module View
      class Select
        attr_reader :selection
        
        def initialize(prompt, options)
          options.each_with_index do |option, index|
            $stderr.print "(#{index + 1}) #{block_given? ? yield(option) : option}\n"
          end
          
          loop do
            $stderr.print "\n#{prompt} "
            user_input = $stdin.gets.chomp
            index = user_input.to_i
            selection = options[index - 1]
            
            if index.to_s != user_input
              $stderr.print "Please make a selection.\n"
            elsif selection.nil?
              $stderr.print "Please select one of the options above.\n"
            else
              @selection = selection
              break
            end
          end
          
          $stderr.print "\n"
        end
      end
    end
  end
end
