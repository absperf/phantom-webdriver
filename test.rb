require 'selenium-webdriver'

driver = Selenium::WebDriver.for :phantomjs
driver.navigate.to "http://google.com"

element = driver.find_element(:name, 'q')
element.send_keys "Hello World!"
element.submit

puts driver.title

driver.quit
