class Actions
  attr_accessor :driver, :timeout

  def initialize(configuration)
    @timeout = 30
    @driver = Selenium::WebDriver.for :phantomjs
    @configuration = configuration
    @driver.navigate.to @configuration.start
    @start_time = Time.now.to_i
  end

  def open(step)
    start_time = Time.now.to_i
    @driver.navigate.to step[:target]
    value = Time.now.to_i - start_time
  end

  def clickAndWait(step)
    start_time = Time.now.to_i
    @driver.find_element(find_element_by_type(step)).click
    wait = Selenium::WebDriver::Wait.new(:timeout => @timeout)
    begin
      wait.until { @driver.execute_script("return document.readyState") == "complete"; }
      value = Time.now.to_i - start_time
      format_metric step, value, "Time", 0, ""
    rescue 
      format_metric step, @timeout, "Time", 2, "Click operation has timed out"
    end
  end

  def click(step)
    @driver.find_element(find_element_by_type(step)).click
  end

  def assertTextPresent(step)
  end

  def type(step)
    @driver.find_element(find_element_by_type(step)).send_keys(step[:args])
  end

  def waitForElementPresent(step)
  end

  def setTimeout(step)
  end

  def setStepName(step)
  end

  def changeFrame(step)
  end

  def assertTitle(step)
  end

  def Total(step)
    total_time = Time.now.to_i - @start_time
    format_metric step, total_time, "Time", 0, ""
  end

  def format_metric(step, value, type, status, message="")
    page = @driver.title
    dkey = "App|#{step[:app]}|#{page}|#{type}|#{step[:order]} #{step[:cmd]}".gsub(/^\s+|\s+$/, "")
    "#{dkey}\t#{value}\t#{status}\t#{message}"
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


