require 'spec_helper'

describe Actions do
  before do
    @actions = Actions.new(double(:start => 'http://code.google.com/p/selenium/wiki/SeIDEReleaseNotes'))
  end

  after do
    @actions.driver.close
  end

  describe '#open' do
    it 'opens the target' do
      step = {:cmd=>"open", :target=>"/p/selenium/wiki/SeIDEReleaseNotes", :args=>"", :link=>"http://code.google.com/p/selenium/wiki/SeIDEReleaseNotes", :app=>"New Test", :order=>1} 
      @actions.open(step)
      @actions.driver.current_url.should =~ /#{step[:target]}/
    end
  end

  describe '#clickAndWait' do
    it 'clicks the element and waits for page to load' do
      step = { :cmd=>"clickAndWait", :target=>"link=Project Home", :args=>"", :link=>"http://code.google.com/p/selenium/wiki/SeIDEReleaseNotes", :app=>"New Test", :order=>2 }
      Selenium::WebDriver::Element.any_instance.should_receive :click
      @actions.clickAndWait(step)
      @actions.driver.execute_script("return document.readyState").should == "complete"
    end
  end

  describe '#type' do
    it 'fills out the element with argument string' do
      step = { :cmd=>"type", :target=>"id=searchq", :args=>"ruby", :link=>"http://code.google.com/p/selenium/wiki/SeIDEReleaseNotes", :app=>"New Test", :order=>6 }
      @actions.driver.find_element(:id => 'searchq').attribute(:value).should == ""
      @actions.type(step)
      @actions.driver.find_element(:id => 'searchq').attribute(:value).should == "ruby"
    end
  end

  describe '#total' do
    it 'returns a metric with the total time' do
      step = { :cmd => "Total", :target => "", :args => "", :link => "http://code.google.com/p/selenium/wiki/SeIDEReleaseNotes", :app => "New Test", :order => 999 }
      sleep 2
      actions = @actions.total(step).split("\t")
      actions[0].should == "App|#{step[:app]}|Time|#{step[:order]} #{step[:cmd]}".gsub(/^\s+|\s+$/,"")
      actions[1].to_i.should == 2
      actions[2].to_i.should == 0
      actions[3].should == nil
    end
  end

end
