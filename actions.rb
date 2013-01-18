class Actions
  attr_accessor :driver

  def initialize(configuration)
    @driver = Selenium::WebDriver.for :phantomjs
    @configuration = configuration
    @driver.navigate.to @configuration.start
  end

  def open(step)
    @driver.navigate.to step[:target]
  end

  def clickAndWait(step)
    @driver.find_element(find_element_by_type(step)).click
  end

  def click(step)
    @driver.find_element(find_element_by_type(step)).click
  end

  def Total(step)
  end

  def type(step)
    @driver.find_element(find_element_by_type(step)).attribute(step[:args])
  end

  def find_link(selector)
    { :link => selector }
  end

  def find_element_by_type(step)
    type, selector = step[:target].split(/(link|css|id|name)=/).reject { |str| str.empty? }
    case type
    when "link"
      find_link selector
    when "css"
      find_css selector
    when "id"
      find_id selector
    when "name"
      find_name selector
    else
      find_xpath step[:target]
    end
  end

  def find_css(selector)
    { :css => selector }
  end

  def find_xpath(target)
    { :xpath => target }
  end

  def find_id(selector)
    { :id => selector }
  end

end


