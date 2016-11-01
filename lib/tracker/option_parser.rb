module Tracker
  module OptionParser
    def self.parse!(argv)
      arguments = {}
      
      ::OptionParser.new do |options|
        options.banner = '### Tracker CLI ###'
        
        options.on '--list OBJECT_TYPE' do |object_type|
          arguments[:method] = :list
          arguments[:object_type] = object_type
        end
        
        options.on '--id OBJECT_ID' do |object_id|
          arguments[:object_id] = object_id
        end
        
        options.on '--fetch OBJECT_TYPE' do |object_type|
          arguments[:method] = :fetch
          arguments[:object_type] = object_type
        end
        
        options.on '--format FORMAT_NAME' do |format_name|
          arguments[:format_name] = format_name
        end
        
        options.on '-i' do
          arguments[:interactive] = true
        end
        
        options.parse!(argv)
      end
      
      arguments
    end
  end
end
