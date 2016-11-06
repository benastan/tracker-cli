require 'spec_helper'

describe Tracker::Cli, config: true, capture_output: true do
  let(:configuration) { { 'api_token' => 'abc123', 'project' => '123999' } }
  
  subject do
    Tracker::Cli.new(argv).tap { rewind_output }
  end
  
  describe '--list' do
    describe 'stories' do
      include_context 'list stories / basic'
      
      let(:argv) { [ '--list', 'stories' ] }
  
      it_behaves_like 'it validates configuration'
      
      it 'lists stories' do
        subject
        
        expect(stdout.read).to eq "00001\t\"Story #1\"\tunstarted\tfeature\n00002\t\"Story #2\"\tdelivered\tchore\n"
      end
      
      describe '--parameter' do
        include_context 'list stories / with label blocked'
        
        before { argv.push('--parameter', 'with_label,blocked') }
        
        it 'sets query params' do
          subject
          
          expect(stdout.read).to eq "00011\t\"Story #4\"\tfinished\tchore\n00012\t\"Story #5\"\tunstarted\tbug\n"
        end
      end
      
      describe '--format json' do
        it 'spits out json' do
          argv.push('--format', 'json')
          
          subject
          
          expect(stdout.read).to eq JSON.dump(list_stories_response)
        end
      end
    end
    
    describe 'memberships' do
      let(:memberships_response) do
        [ { id: 1, person: { name: 'Contributor #1', initials: 'C1' } }, { id: 2, person: { name: 'Contributor #2', initials: 'C2' } }, { id: 3, person: { name: 'Contributor #3', initials: 'C3' } } ]
      end
      
      let(:argv) { [ '--list', 'memberships' ] }
  
      it_behaves_like 'it validates configuration'
      
      before { stub_api("projects/123999/memberships", memberships_response) }
      
      it 'lists memberships' do
        subject
        
        expect(stdout.read).to eq "1\tC1\t\"Contributor #1\"\n2\tC2\t\"Contributor #2\"\n3\tC3\t\"Contributor #3\"\n"
      end
      
      describe '--format json' do
        it 'spits out json' do
          argv.push('--format', 'json')
          
          subject
          
          expect(stderr.read).to eq ''
          expect(stdout.read).to eq JSON.dump(memberships_response)
        end
      end
    end
  
    describe 'projects' do
      include_context 'list projects / basic'
      
      let(:argv) { [ '--list', 'projects' ] }
  
      it_behaves_like 'it validates configuration'
      
      it 'lists project' do
        subject
        
        expect(stdout.read).to eq "90001\t\"Project #1\"\n90002\t\"Project #2\"\n"
      end
      
      describe '--format json' do
        it 'spits out json' do
          argv.push('--format', 'json')
          
          subject
          
          expect(stdout.read).to eq JSON.dump(list_projects_response)
        end
      end
    end
  end
  
  describe '--fetch' do
    describe 'story' do
      let(:argv) { [ '--fetch', 'story', '--id', '00001' ] }
      
      describe '--id STORY_ID' do
        before do
          stub_api("stories/00001",
            'id' => '00001',
            'name' => 'Story #1'
          )
        end
        
        it_behaves_like 'it validates configuration'
      
        it 'fetches information about the story' do
          subject
          
          expect(stdout.read).to eq "00001\t\"Story #1\"\n"
        end
        
        describe '--commit' do
          before { argv.push('--commit') }
          
          it_behaves_like 'it validates configuration'

          it 'makes a commit' do
            allow(Open3).to receive(:popen2).and_return([ nil, double(read: "Committed!\n")])
            subject
            
            expect(stderr.read).to eq "Committed!\n"
            expect(Open3).to have_received(:popen2).with('git', 'commit', '-m', '"[#00001] Story #1"')
          end
        end
      end
      
      describe '-i' do
        include_context 'list stories / basic'
        let(:argv) { [ '--fetch', 'story', '-i' ] }
  
        it_behaves_like 'it validates configuration'
  
        it 'lets user choose the story and fetches information about the selected story' do
          allow($stdin).to receive(:gets).and_return("1\n")
          subject
    
          expect(stderr.read).to eq "(1) 00001 \"Story #1\"\n(2) 00002 \"Story #2\"\n\nWhich Story? \n"
          expect(stdout.read).to eq "00001\t\"Story #1\"\n"
        end
        
        describe '--parameter' do
          include_context 'list stories / with label blocked'
  
          before { argv.push('--parameter', 'with_label,blocked') }
  
          it 'sets query params' do
            allow($stdin).to receive(:gets).and_return("1\n")
            subject
            
            expect(stderr.read).to eq "(1) 00011 \"Story #4\"\n(2) 00012 \"Story #5\"\n\nWhich Story? \n"
            expect(stdout.read).to eq "00011\t\"Story #4\"\n"
          end
        end
      end
    end
  end

  describe '--create' do
    describe 'story' do
      let(:argv) { [ '--create', 'story' ] }

      context 'when parameters are provided' do
        it 'creates a story' do
          argv.push('--parameter', 'name,User can create a story')
          
          stub_api('projects/123999/stories', { id: 1, name: 'User can create a story' }, method: :post, body: { name: 'User can create a story' })
          
          subject
          
          expect(stdout.read).to eq '{"id":1,"name":"User can create a story"}'
        end
      end
      
      describe '-i' do
        it 'creates a story interactively' do
          argv.push('-i')
          stub_api('projects/123999/stories', { id: 1, name: 'User can create a story', story_type: :bug }, method: :post, body: { name: 'User can create a story', story_type: :bug })
          allow($stdin).to receive(:gets).and_return("User can create a story\n", "2\n")
          
          subject
          
          expect(stderr.read).to eq "Name? \n(1) feature\n(2) bug\n(3) chore\n(4) release\n\nWhat type of story is this? \n"
          expect(stdout.read).to eq "{\"id\":1,\"name\":\"User can create a story\",\"story_type\":\"bug\"}"
        end
      end
    end
    
    describe 'project' do
      let(:argv) { [ '--create', 'project' ] }
      
      context 'when parameters are provided' do
        it 'creates a project' do
          argv.push('--parameter', 'name,Project Name')
          stub_api('projects', { id: 90001, name: 'Project Name'}, method: :post, body: { name: 'Project Name' })
          
          subject
          
          expect(stdout.read).to eq '{"id":90001,"name":"Project Name"}'
        end
      end
      
      describe '-i' do
        it 'creates a project interactively' do
          argv.push('-i')
          stub_api('projects', { id: 90001, name: 'Project Name'}, method: :post, body: { name: 'Project Name', no_owner: true })
          allow($stdin).to receive(:gets).and_return("Project Name\n", "y\n")
          
          subject
          
          expect(stderr.read).to eq "Name? \nNo owner (y/n)? \n"
          expect(stdout.read).to eq "{\"id\":90001,\"name\":\"Project Name\"}"
        end
      end
    end
  end
  
  describe '--destroy' do
    describe 'project' do
      let(:argv) { [ '--destroy', 'project', '--id', '90001'] }
      
      it 'destroys a project' do
        stub_api('projects/90001', { id: 90001, name: 'Project Name' })
        stub_api('projects/90001', {}, method: :delete)

        allow(Tracker::Cli::View::Confirm).to receive(:new).with('Project Name').and_return(double(confirmed?: true))
        
        subject
        
        expect(stderr.read).to eq "Warning: Destructive Action!\n\n"
        expect(stdout.read).to eq "{}"
      end
      
      context 'when the project does not exist' do
        it 'prints error messages' do
          stub_api('projects/90001', {
            error: 'Error',
            general_problem: 'General problem',
            possible_fix: 'Possible fix',
          }, status: 403)
      
          subject
          
          expect(stderr.read).to eq "Error\nGeneral problem\nPossible fix\n"
          expect(stdout.read).to eq ""
        end
      end
    end
  end
  
  describe '--get accounts' do
    let(:argv) { [ '--get', 'accounts' ] }
    
    it 'gets the requested url' do
      stub_api('accounts', [ { id: 1, name: 'First User' } ])
      
      subject
      
      expect(stdout.read).to eq '[{"id":1,"name":"First User"}]'
    end
  end
end
