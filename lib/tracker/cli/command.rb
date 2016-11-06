module Tracker
  class Cli
    module Command
      autoload :Fetch, 'tracker/cli/command/fetch'
      autoload :List, 'tracker/cli/command/list'
      autoload :Create, 'tracker/cli/command/create'
      autoload :Destroy, 'tracker/cli/command/destroy'
    end
  end
end