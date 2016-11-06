require 'spec_helper'

describe Tracker::Cli::View::Confirm, capture_output: true do
  subject { described_class.new('Hi!').tap { rewind_output } }
  
  context 'when the correct string is inputted' do
    it 'is confirmed' do
      allow($stdin).to receive(:gets).and_return("Hi!\n")
      
      expect(subject).to be_confirmed
      expect(stderr.read).to eq "Type \"Hi!\" to confirm: \n\n"
    end
  end
  
  context 'when the incorrect string is inputted' do
    it 'is not confirmed' do
      allow($stdin).to receive(:gets).and_return("Hello?\n")
      
      expect(subject).to_not be_confirmed
      expect(stderr.read).to eq "Type \"Hi!\" to confirm: \n\n"
    end
  end
end
