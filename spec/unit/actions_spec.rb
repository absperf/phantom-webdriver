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
    context 'no timeout' do
      it 'clicks the element and waits for page to load' do
        step = { :cmd=>"clickAndWait", :target=>"link=Project Home", :args=>"", :link=>"http://code.google.com/p/selenium/wiki/SeIDEReleaseNotes", :app=>"New Test", :order=>2 }
        Selenium::WebDriver::Element.any_instance.should_receive :click
        actions = @actions.clickAndWait(step).split("\t")
        @actions.driver.execute_script("return document.readyState").should == "complete"
        actions[0].should == "App|#{step[:app]}|#{@actions.driver.title}|Time|#{step[:order]} #{step[:cmd]}".gsub(/^\s+|\s+$/,"")
      end
    end

    context 'timeout' do
      it 'clicks the element and waits for timeout message' do
        step = { :cmd=>"clickAndWait", :target=>"link=Project Home", :args=>"", :link=>"http://code.google.com/p/selenium/wiki/SeIDEReleaseNotes", :app=>"New Test", :order=>2 }
        @actions.timeout = 0
        Selenium::WebDriver::Element.any_instance.should_receive :click
        actions = @actions.clickAndWait(step).split("\t")
        @actions.driver.execute_script("return document.readyState").should_not == "complete"
        actions[0].should == "App|#{step[:app]}|#{@actions.driver.title}|Time|#{step[:order]} #{step[:cmd]}".gsub(/^\s+|\s+$/,"")
        actions[2].should == "2"
        actions[3].should == "Click operation has timed out"
      end
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

  describe '#assertTextPresent' do
    context 'is present' do
      it 'asserts text' do
        step = { :cmd => "type", :target => "google", :args => "", :link=>"http://code.google.com/p/selenium/wiki/SeIDEReleaseNotes", :app=>"New Test", :order=>6 }
        action = @actions.assertTextPresent(step).split("\t")
        action[0].should == "App|#{step[:app]}|#{@actions.driver.title}|Validate|#{step[:order]} #{step[:cmd]}".gsub(/^\s+|\s+$/, "")
        action[1].should == "1"
        action[2].should == "0"
        action[3].should == nil
      end

      it 'asserts xpath' do
        step = { :cmd => "type", :target => "//title", :args => "", :link=>"http://code.google.com/p/selenium/wiki/SeIDEReleaseNotes", :app=>"New Test", :order=>6 }
        action = @actions.assertTextPresent(step).split("\t")
        action[0].should == "App|#{step[:app]}|#{@actions.driver.title}|Validate|#{step[:order]} #{step[:cmd]}".gsub(/^\s+|\s+$/, "")
        action[1].should == "1"
        action[2].should == "0"
        action[3].should == nil
      end

      it 'asserts regex' do
        step = { :cmd => "type", :target => "regex:google", :args => "", :link=>"http://code.google.com/p/selenium/wiki/SeIDEReleaseNotes", :app=>"New Test", :order=>6 }
        action = @actions.assertTextPresent(step).split("\t")
        action[0].should == "App|#{step[:app]}|#{@actions.driver.title}|Validate|#{step[:order]} #{step[:cmd]}".gsub(/^\s+|\s+$/, "")
        action[1].should == "1"
        action[2].should == "0"
        action[3].should == nil
      end
    end

    context 'is not present' do
      it 'asserts text' do
        step = { :cmd => "type", :target => "goooooogle", :args => "", :link => "http://code.google.com/p/selenium/wiki/SeIDEReleaseNotes", :app=>"New Test", :order=>6 }

        action = @actions.assertTextPresent(step).split("\t")
        action[0].should == "App|#{step[:app]}|#{@actions.driver.title}|Validate|#{step[:order]} #{step[:cmd]}".gsub(/^\s+|\s+$/, "")
        action[1].should == "0"
        action[2].should == "2"
        action[3].should == "Assert Text Failed: expected to match '#{step[:target]}', but that text wasn't found"
      end

      it 'asserts xpath' do
        step = { :cmd => "type", :target => "//title123", :args => "", :link=>"http://code.google.com/p/selenium/wiki/SeIDEReleaseNotes", :app=>"New Test", :order=>6 }
        action = @actions.assertTextPresent(step).split("\t")
        action[0].should == "App|#{step[:app]}|#{@actions.driver.title}|Validate|#{step[:order]} #{step[:cmd]}".gsub(/^\s+|\s+$/, "")
        action[1].should == "0"
        action[2].should == "2"
        action[3].should == "Assert Text Failed: expected to match '#{step[:target]}', but that xpath wasn't found"
      end

      it 'asserts regex' do
        step = { :cmd => "type", :target => "regex:abc1230", :args => "", :link=>"http://code.google.com/p/selenium/wiki/SeIDEReleaseNotes", :app=>"New Test", :order=>6 }
        action = @actions.assertTextPresent(step).split("\t")
        action[0].should == "App|#{step[:app]}|#{@actions.driver.title}|Validate|#{step[:order]} #{step[:cmd]}".gsub(/^\s+|\s+$/, "")
        action[1].should == "0"
        action[2].should == "2"
        action[3].should == "Assert Text Failed: expected to match '#{step[:target]}', but that regex wasn't found"
      end
    end
  end

  describe '#waitForElementPresent' do
  end

  describe '#setTimeout' do
  end

  describe '#setStepName' do
  end

  describe '#changeFrame' do
  end

  describe '#assertTitle' do
  end

  describe '#Total' do
    it 'returns a metric with the total time' do
      step = { :cmd => "Total", :target => "", :args => "", :link => "http://code.google.com/p/selenium/wiki/SeIDEReleaseNotes", :app => "New Test", :order => 999 }
      sleep 2
      actions = @actions.Total(step).split("\t")
      actions[0].should == "App|#{step[:app]}|#{@actions.driver.title}|Time|#{step[:order]} #{step[:cmd]}".gsub(/^\s+|\s+$/,"")
      actions[1].to_i.should == 2
      actions[2].to_i.should == 0
      actions[3].should == nil
    end
  end

end
