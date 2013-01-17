require 'spec_helper'

describe Walker do
  describe '#initialize' do
    it 'sets the address' do
      address = "#{Dir.pwd}/spec/fixtures/google.html"
      walker = Walker.new address
      walker.instance_variable_get(:@address).should == address
    end
  end

  describe '#open_config' do
    context 'exists' do
      it 'returns a configuration' do
        address = "file://#{Dir.pwd}/spec/fixtures/google.html"
        walker = Walker.new address
        walker.open_config
        walker.configuration.should_not == nil
        walker.configuration.class.should == Configuration
      end
    end

    context 'can\'t find a configuration' do
      it 'exits' do
        address = "file://#{Dir.pwd}/spec/fixtures/blaah.html"
        walker = Walker.new address
        -> { walker.open_config }.should raise_error SystemExit
      end
    end
  end

  describe '#evaluate_steps' do
    it 'returns hash of steps' do
      address = "file://#{Dir.pwd}/spec/fixtures/google.html"
      walker = Walker.new address
      walker.open_config
      evaluated_steps = walker.evaluate_steps
      evaluated_steps.should include({ :cmd => 'Total', :target => '', :args => '', :link => 'https://www.google.com/', :app => 'New Test', :order => 999 } )
      evaluated_steps.should include({ :cmd => 'clickAndWait', :target => 'id=gb_78', :args => '', :link => 'https://www.google.com/', :app => 'New Test', :order => 4 })
      evaluated_steps.should include({ :cmd => 'clickAndWait', :target => 'id=gb_8', :args => '', :link => 'https://www.google.com/', :app => 'New Test', :order => 3 })
      evaluated_steps.should include({ :cmd => 'clickAndWait', :target => 'css=#gb_2 > span.gbts', :args => '', :link => 'https://www.google.com/', :app => 'New Test', :order => 2 })
      evaluated_steps.should include({ :cmd => 'open', :target => '/', :args => '', :link => 'https://www.google.com/', :app => 'New Test', :order => 1 })
    end
  end

end

describe Configuration do
  let(:config) { address = "file://#{Dir.pwd}/spec/fixtures/google.html"; Configuration.new(Typhoeus.get(address).response_body) }

  describe '#initialize' do
    it 'creates a nokogiri object' do
      config.instance_variable_get(:@document).class.should == Nokogiri::XML::Document 
    end
  end

  describe '#steps' do
    it 'returns steps' do
      steps = config.steps
      steps.class.should == Array
      steps.should include ['open', '/']
      steps.should include ['clickAndWait', 'css=#gb_2 > span.gbts']
      steps.should include ['clickAndWait', 'id=gb_8']
      steps.should include ['clickAndWait', 'id=gb_78']
    end
  end

  describe '#start' do
    it 'returns start snippet' do
      config.start.should == 'https://www.google.com/'
    end
  end

  describe '#title' do
    it 'returns title' do
      config.title.should == 'New Test'
    end
  end

end
