require 'spec_helper'

describe Walker do
 # it_behaves_like Actions

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

  describe '#take_action' do

    subject { address = "file://#{Dir.pwd}/spec/fixtures/selenium.html"; Walker.new address }
    it 'calls .open method on Action module' do
      #pending 'Can\'t test class methods'
      subject.open_config
      subject.take_action
      #subject.should_receive('open')
     # Actions.should_receive(:clickAndWait)
      #Actions.should_receive(:Total)
    end
  end

end

