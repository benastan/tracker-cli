module Tracker
  class Cli
    module View
      class Select
        attr_reader :selection
        
        def initialize(prompt, options)
          options.each_with_index do |option, index|
            print "(#{index + 1}) #{block_given? ? yield(option) : option}\n"
          end
          
          print "\n#{prompt} "
          index = $stdin.gets.chomp.to_i - 1
          @selection = options[index]
          print "\n"
        end
      end
    end
  end
end
