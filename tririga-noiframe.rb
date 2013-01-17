require 'selenium-webdriver'

driver = Selenium::WebDriver.for :phantomjs
driver.navigate.to 'http://tririga.chipotle.com/html/en/default/login/loginMain.jsp'

driver.find_element(:name => 'USERNAME').attribute('webwalk_serv')
driver.find_element(:name => 'PASSWORD').attribute('password')
driver.find_element(:class => 'loginButton').click()
puts driver.title

wait = Selenium::WebDriver::Wait.new(:timeout => 10)
wait.until { driver.find_element(:xpath => "//html/body/div[3]/div[5]/div/div/div/div/div/div/div[2]/div/div/div/div/div/div/div[2]/div/div[2]/div/div/div[2]/div/a[@href=\"#name=Record+Add+-+Create+RE+Project\"]") }
driver.quit
