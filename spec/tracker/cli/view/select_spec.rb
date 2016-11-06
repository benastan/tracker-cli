require 'spec_helper'

describe Tracker::Cli::View::Select, capture_stdout: true do
  let(:options) do
    [
      [:hello, 'Hello'],
      [ :hi, 'Hi' ],
      [ :hola, 'Hola' ],
      [ :guten_tag, 'Guten Tag' ]
    ]
  end
  
  subject do
    described_class.new('Which option?', options) { |option| option[1] }.tap { stdout.rewind }
  end
  
  it 'determines selection via user input' do
    allow($stdin).to receive(:gets).and_return("2\n")
    
    subject
    
    expect(subject.selection).to eq [ :hi, 'Hi' ]
    expect(stdout.read).to eq "(1) Hello\n(2) Hi\n(3) Hola\n(4) Guten Tag\n\nWhich option? \n"
  end
end
