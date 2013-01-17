require 'spec_helper'

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
