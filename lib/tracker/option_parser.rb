module Tracker
  module OptionParser
    def self.parse!(argv)
      arguments = {}
      
      ::OptionParser.new do |options|
        options.banner = <<-BANNER

tracker --list OBJECT_TYPE (--format FORMAT_NAME)
tracker --fetch OBJECT_TYPE (--id OBJECT_ID)(-i)

BANNER
        
        options.on '--list OBJECT_TYPE', 'one of: stories, projects' do |object_type|
          arguments[:method] = :list
          arguments[:object_type] = object_type
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
        
        options.on '-i', 'interactive --fetch' do
          arguments[:interactive] = true
        end
        
        options.parse!(argv)
      end
      
      arguments
    end
  end
end
