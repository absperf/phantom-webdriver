require 'spec_helper'

describe Actions do
  let(:configuration) { stub(:start).and_return('http://code.google.com/p/selenium/wiki/SeIDEReleaseNotes') }
  let(:actions) { Actions.new(configuration) }

  describe '#open' do
    it 'opens the target' do
      step = {:cmd=>"open", :target=>"/p/selenium/wiki/SeIDEReleaseNotes", :args=>"", :link=>"http://code.google.com/p/selenium/wiki/SeIDEReleaseNotes", :app=>"New Test", :order=>1} 
    end
  end

  describe '#clickAndWait' do
  end

  describe '#type' do
    it 'fills out the element with argument string' do
      step = {:cmd=>"type", :target=>"id=searchq", :args=>"ruby", :link=>"http://code.google.com/p/selenium/wiki/SeIDEReleaseNotes", :app=>"New Test", :order=>6}

    end
  end

  describe '#Total' do
  end

end
