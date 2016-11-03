module Tracker
  class Client < Faraday::Connection
    def initialize(api_token)
      super('https://www.pivotaltracker.com/services/v5') do | builder |
        builder.headers['X-Tracker-Token'] = api_token
        builder.headers['X-TrackerToken'] = api_token
        builder.response :json
        builder.adapter Faraday.default_adapter
      end
    end
    
    def fetch(object_type = nil, query: nil, **url_parameters)
      query ||= {}
      url = url_parameters.to_a.flatten.concat([object_type]).compact.join('/')
      get(url, query).body
    end
  end
end