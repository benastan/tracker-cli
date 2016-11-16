module Tracker
  module OptionParser
    def self.parse!(argv)
      arguments = {}
      
      ::OptionParser.new do |options|
        options.banner = <<-BANNER

tracker --list OBJECT_TYPE (--format FORMAT_NAME) (--parameter key,value)
tracker --fetch OBJECT_TYPE --id OBJECT_ID (--commit)
                            -i (--parameter key,value) (--commit)
tracker --create OBJECT_TYPE (-i) (--parameter key,value ...)
tracker --destroy OBJECT_TYPE --id OBJECT_ID
tracker --get URL

BANNER
        
        options.separator "\n\e[37mLIST\e[0m"
        options.on '--list OBJECT_TYPE', 'one of: accounts, memberships, projects, stories' do |object_type|
          arguments[:method] = :list
          arguments[:object_type] = object_type
        end
        
        options.on '--parameter QUERY_PARAM', 'set a query param for get requests in the form of key,value. Can be used multiple times. See https://www.pivotaltracker.com/help/api/rest/v5 for possible keys', Array do |query_param|
          arguments[:query_params] ||= {}
          key, value, *_ = query_param
          arguments[:query_params][key] = value
          
        end
        
        options.on '--format FORMAT_NAME', 'none (default), json' do |format_name|
          arguments[:format_name] = format_name
        end
  
        options.separator "\n\e[37mFETCH\e[0m"
  
        options.on '--fetch OBJECT_TYPE', 'story' do |object_type|
          arguments[:method] = :fetch
          arguments[:object_type] = object_type
        end
  
        options.on '--id OBJECT_ID', 'OBJECT_ID for --fetch' do |object_id|
          arguments[:object_id] = object_id
        end
        
        options.on '-i', 'interactive --fetch or --create' do
          arguments[:interactive] = true
        end
        
        options.on '--commit', 'make a commit (must be used with --fetch story)' do
          arguments[:commit] = true
        end
  
        options.separator "\n\e[37mCREATE\e[0m"
  
        options.on '--create OBJECT_TYPE', 'create a project or story' do |object_type|
          arguments[:method] = :create
          arguments[:object_type] = object_type
        end
  
        options.separator "\n\e[37mDESTROY\e[0m"

        options.on '--destroy OBJECT_TYPE', 'destroy a project' do |object_type|
          arguments[:method] = :destroy
          arguments[:object_type] = object_type
        end
  
        options.separator "\n\e[37mGET\e[0m"
  
        options.on '--get URL', 'get a url endpoint' do |url|
          arguments[:method] = :request
          arguments[:request_method] = :get
          arguments[:url] = url
        end
        
        options.parse!(argv)
      end
      
      arguments
    end
  end
end

