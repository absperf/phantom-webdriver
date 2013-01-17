class Actions

  def initialize(driver, configuration)
    @driver = driver
    @configuration = configuration
    @driver.navigate.to @configuration.start
  end

  def open(step)
    @driver.navigate.to step[:target]
  end

  def clickAndWait(step)
    @driver.find_element(find_element_by_type(step[:target])).click
    # click
    # wait for new page to load
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  def Total(step)
  end

  def find_element_by_type(target)
    type, selector = target.split '='
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
      find_xpath target
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


