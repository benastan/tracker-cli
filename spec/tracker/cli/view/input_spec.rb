require 'spec_helper'

describe Tracker::Cli::View::Input, capture_output: true do
  subject { described_class.new('Name').tap { rewind_output } }
  
  describe 'default type' do
    it 'fetches input' do
      allow($stdin).to receive(:gets).and_return("User input\n")
      
      subject
      
      expect(subject.value).to eq "User input"
      expect(stderr.read).to eq "Name? \n"
    end

    it 'requires input' do
      allow($stdin).to receive(:gets).and_return("\n", "User input\n")
      
      subject
      
      expect(subject.value).to eq "User input"
      expect(stderr.read).to eq "Name? \nCannot be blank.\nName? \n"
    end
  end
  
  describe 'boolean input' do
    subject { described_class.new('Agree to disagree', type: :boolean).tap { rewind_output } }
  
    context 'when the answer is "y"' do
      it 'is yes' do
        allow($stdin).to receive(:gets).and_return("y\n")
      
        subject
      
        expect(subject.value).to eq true
        expect(stderr.read).to eq "Agree to disagree (y/n)? \n"
      end
    end
    
    context 'when the answer is "n"' do
      it 'is no' do
        allow($stdin).to receive(:gets).and_return("n\n")
      
        subject
        
        expect(subject.value).to eq false
        expect(stderr.read).to eq "Agree to disagree (y/n)? \n"
      end
    end

    context 'when the answer is neither "y" nor "n"' do
      it 'prompts until it receives a valid response' do
        allow($stdin).to receive(:gets).and_return("foo\n", "y\n")
      
        subject
        
        expect(subject.value).to eq true
        expect(stderr.read).to eq "Agree to disagree (y/n)? \nPlease provide either \"y\" or \"n\"\nAgree to disagree (y/n)? \n"
      end
    end
  end
end
