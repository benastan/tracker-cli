require 'bundler'
Bundler.require
require 'webmock/rspec'
$LOAD_PATH.push(File.expand_path(__FILE__)+'/lib')
require 'tracker'

RSpec.configure do |config|
  config.before(:each) do
    WebMock.enable!
  end
  
  config.before(:each, config: true) do
    allow(File).to receive(:exist?).
      with(Tracker.configuration_file_location).
      and_return(true)
    
    allow(File).to receive(:read).
      with(Tracker.configuration_file_location).
      and_return(Psych.dump(configuration))
  end
  
  config.before(:each, config: false) do
    allow(File).to receive(:exist?).
      with(Tracker.configuration_file_location).
      and_return(false)
  end
end

shared_examples 'it validates configuration' do
  context 'when the access token is missing' do
    let(:configuration) { { 'project' => '123999' } }
    
    it 'blows up' do
      expect{subject}.to raise_error(ArgumentError, "API Token missing. Find yours at https://www.pivotaltracker.com/profile and add: \n\napi_token: {{YOUR_TOKEN}}\n\n to ~/.tracker.config")
    end
  end
  
  context 'when the project is missing' do
    let(:configuration) { { 'api_token' => 'abc123' } }
    
    it 'blows up' do
      expect{subject}.to raise_error(ArgumentError, "Project id is missing. Find the id in the url for the project and add: \n\nproject: {{YOUR_PROJECT_ID}}\n\n to ~/.tracker.config")
    end
  end
end

def stub_api(endpoint, response_body, status: 200, method: :get, body: nil)
  with_arguments = {
    headers: {
      'X-Tracker-Token' => 'abc123'
    }
  }
  
  with_arguments[:body] = URI.encode_www_form(body) if body
  
  stub_request(method, "https://www.pivotaltracker.com/services/v5/#{endpoint}").
    with(with_arguments).
    to_return(
      status: status,
      body: JSON.dump(response_body)
    )
end

shared_context 'list stories / basic' do
  let(:list_stories_response) do
    [
      { 'id' => '00001', 'name' => 'Story #1', current_state: 'unstarted', story_type: 'feature' },
      { 'id' => '00002', 'name' => 'Story #2', current_state: 'delivered', story_type: 'chore' },
    ]
  end

  before { stub_api("projects/123999/stories", list_stories_response) }
end

shared_context 'list stories / with label blocked' do
  let(:list_stories_with_label_blocked_response) {
    [
      { 'id' => '00011', 'name' => 'Story #4', current_state: 'finished', story_type: 'chore' },
      { 'id' => '00012', 'name' => 'Story #5', current_state: 'unstarted', story_type: 'bug' }
    ]
  }
  
  before { stub_api("projects/123999/stories?with_label=blocked", list_stories_with_label_blocked_response) }
end

shared_context 'list projects / basic' do
  let(:list_projects_response) do
    [
      { 'id' => '90001', 'name' => 'Project #1' },
      { 'id' => '90002', 'name' => 'Project #2' },
    ]
  end

  before { stub_api("projects", list_projects_response) }
end

shared_context 'capture stdout', capture_output: true do
  let(:stdout) { StringIO.new }
  let(:stderr) { StringIO.new }
  
  def rewind_output
    stdout.rewind
    stderr.rewind
  end
  
  around(:each, capture_output: true) do |example|
    $stdout = stdout
    $stderr = stderr
    
    timeout_error = nil
    
    begin
      Timeout::timeout(1) do
        example.run
      end
    rescue Timeout::Error => e
      rewind_output
      timeout_error = e
    end
    
    $stderr = STDERR
    $stdout = STDOUT
    
    if timeout_error
      print "Timed out after 1 seconds.\n"
      print "\nStandard out:\n"
      print stdout.read
      # print "\nStandard error:\n"
      # print stderr.read
      print "\nBacktrace:\n"
      print timeout_error.backtrace.join("\n")
    end
  end
end
