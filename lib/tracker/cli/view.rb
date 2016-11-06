module Tracker
  class Cli
    module View
      autoload :Confirm, 'tracker/cli/view/confirm'
      autoload :Select, 'tracker/cli/view/select'
      autoload :Input, 'tracker/cli/view/input'
    end
  end
end
