module Tracker
  class Cli
    module Command
      autoload :Fetch, 'tracker/cli/command/fetch'
      autoload :List, 'tracker/cli/command/list'
    end
  end
end