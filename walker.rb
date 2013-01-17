require 'typhoeus'
require 'nokogiri'

class Walker
  attr_reader :configuration

  def initialize(address)
    @address = address
  end

  def open_config
    config = Typhoeus.get(@address)
    exit if config.return_code != :ok
    @configuration = Configuration.new(config.response_body.gsub("\n", ""))
  end

  def evaluate_steps
    ret = []
    @configuration.steps.each_with_index do |step, i|
      order = i + 1
      cmd = step[0]
      target = step[1]
      args = step[2] || ""
      ret << { :cmd => cmd, :target => target, :args => args, :link => @configuration.start, :app => @configuration.title }
    end
    ret << { :cmd => 'Total', :target => '', :args => '', :link => @configuration.start, :app => @configuration.title, :order => 999 }
  end
end

class Configuration
  def initialize(configuration_text)
    @document = Nokogiri::XML(configuration_text)
  end

  def steps
    @document.css('tbody > tr').map do |row|
      row.css('td').children.map { |td| td.text }
    end
  end

  def start
    @document.at_css('head > link').attributes['href'].text
  end

  def title
    @document.at_css('title').children.first.text
  end

end
