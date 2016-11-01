require 'spec_helper'

describe Tracker do
  describe '.api_token' do
    context 'when there is no api token', config: false do
      it 'is nil' do
        api_token = Tracker.api_token
        expect(api_token).to be_nil
      end
    end
    
    context 'when there is an api token', config: true do
      let(:configuration) { { 'api_token' => 'abc123' } }
      
      it 'is nil' do
        api_token = Tracker.api_token
        expect(api_token).to eq 'abc123'
      end
    end
  end

  describe '.project' do
    context 'when there is no project', config: false do
      it 'is nil' do
        project = Tracker.project
        expect(project).to be_nil
      end
    end
    
    context 'when there is an project', config: true do
      let(:configuration) { { 'project' => '123999' } }
      
      it 'is nil' do
        project = Tracker.project
        expect(project).to eq '123999'
      end
    end
  end
end
