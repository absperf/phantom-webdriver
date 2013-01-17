require 'typhoeus'
require 'nokogiri'
require_relative 'configuration'

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
      ret << { :cmd => cmd, :target => target, :args => args, :link => @configuration.start, :app => @configuration.title, :order => order}
    end
    ret << { :cmd => 'Total', :target => '', :args => '', :link => @configuration.start, :app => @configuration.title, :order => 999 }
  end

  def take_action
    steps = evaluate_steps()
  end
end

