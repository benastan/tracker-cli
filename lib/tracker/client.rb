module Tracker
  class Client < Faraday::Connection
    def initialize(api_token)
      super('https://www.pivotaltracker.com/services/v5') do | builder |
        builder.headers['X-Tracker-Token'] = api_token
        builder.response :json
        builder.adapter Faraday.default_adapter
      end
    end
    
    def fetch_stories(project: )
      get("projects/#{project}/stories").body
    end
    
    def fetch_story(story_id)
      get("stories/#{story_id}").body
    end
  end
end