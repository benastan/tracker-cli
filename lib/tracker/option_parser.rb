module Tracker
  module OptionParser
    def self.parse!(argv)
      arguments = {}
      
      ::OptionParser.new do |options|
        options.banner = <<-BANNER

tracker --list OBJECT_TYPE (--format FORMAT_NAME)
tracker --fetch OBJECT_TYPE (--id OBJECT_ID)(-i)

BANNER
        
        options.on '--list OBJECT_TYPE', 'one of: stories, projects, accounts' do |object_type|
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
        
        options.on '--commit', 'make a commit' do
          arguments[:commit] = true
        end
        
        options.on '--create OBJECT_TYPE', 'create a project or story' do |object_type|
          arguments[:method] = :create
          arguments[:object_type] = object_type
        end

        options.on '--destroy OBJECT_TYPE', 'create a project' do |object_type|
          arguments[:method] = :destroy
          arguments[:object_type] = object_type
        end
        
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
