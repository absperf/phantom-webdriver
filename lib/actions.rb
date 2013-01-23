class Actions
  attr_accessor :driver, :timeout

  def initialize(configuration, driver)
    @timeout = 30
    @driver = driver
    @configuration = configuration
    @driver.navigate.to @configuration.start
    @start_time = Time.now.to_i
  end

  def open(step)
    start_time = Time.now.to_i
    @driver.navigate.to step[:target]
    value = Time.now.to_i - start_time
    format_metric step, value, "Time", 0, ""
  end

  def clickAndWait(step)
    start_time = Time.now.to_i
    if click(step) == true
      wait = Selenium::WebDriver::Wait.new(:timeout => @timeout)
      begin
        wait.until { @driver.execute_script("return document.readyState") == "complete"; }
        value = Time.now.to_i - start_time
        format_metric step, value, "Time", 0, ""
      rescue 
        format_metric step, @timeout, "Time", 2, "Click operation has timed out"
      end
    end
  end

  def click(step)
    begin
      @driver.find_element(find_element_by_type(step)).click
      true
    rescue
      nil
    end
  end

  def assertTextPresent(step)
    message = ""
    status = 0
    success = 1

    if step[:target][0..1] == '//'
      begin
        @driver.find_element :xpath => step[:target]
      rescue
        status = 2
        success = 0
        message = "Assert Text Failed: expected to match '#{step[:target]}', but that xpath wasn't found"
      end
    elsif step[:target][0..5] == 'regex:'
      regex = step[:target][6..-1]
      if (@driver.page_source =~ /#{regex}/).nil?
        status = 2
        success = 0
        message = "Assert Text Failed: expected to match '#{step[:target]}', but that regex wasn't found"
      end
    else
      if !@driver.page_source.include? step[:target]
        status = 2
        success = 0
        message = "Assert Text Failed: expected to match '#{step[:target]}', but that text wasn't found"
      end
    end

    format_metric step, success, "Validate", status, message
  end

  def type(step)
    begin
      @driver.find_element(find_element_by_type(step)).send_keys(step[:args])
    rescue
    end
    nil
  end

  def waitForElementPresent(step)
    start_time = Time.now.to_i
    message = ""
    status = 0
    wait = Selenium::WebDriver::Wait.new :timeout => @timeout
    begin
      value = Time.now.to_i - start_time 
      wait.until { @driver.find_element(find_element_by_type(step)) }
    rescue
      value = @timeout
      status = 2
      message = "A wait operation (#{step[:order]} #{step[:cmd]}) has timed out." 
    end

    format_metric step, value, "Time", status, message
  end

  def setTimeout(step)
    self.timeout = step[:target]
    nil
  end

  def setStepName(step)
    @step_name = step[:target]
    nil
  end

  def changeFrame(step)
    iframe = @driver.find_element(:id => step[:target])
    @driver.switch_to.frame iframe
    nil
  end

  def assertTitle(step)
    message = ""
    success = 1
    status = 0
    unless @driver.title == step[:target]
      success = 0
      status = 2
      message = "Assert Title Failed: expected to find #{step[:target]}, but it is #{@driver.title}"
    end

    format_metric step, success, "Validate", status, message
  end

  def Total(step)
    total_time = Time.now.to_i - @start_time
    format_metric step, total_time, "Time", 0, ""
  end

  def format_metric(step, value, type, status, message="")
    page = @step_name || @driver.title
    dkey = "App|#{step[:app]}|#{page}|#{type}|#{step[:order]} #{step[:cmd]}".gsub(/^\s+|\s+$/, "")
    clear_step_name
    "#{dkey}\t#{value}\t#{status}\t#{message}"
  end

  def clear_step_name
    @step_name = nil
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

  def find_name(target)
    { :name => target } 
  end

  def find_id(selector)
    { :id => selector }
  end

end


