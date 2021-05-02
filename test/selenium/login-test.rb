require "selenium-webdriver"
require "test/unit"


class LoginClass < Test::Unit::TestCase
 
  def setup
    @driver = Selenium::WebDriver.for :chrome
    @driver.get('https://noteswsd2021.herokuapp.com/')
    @driver.manage.window.maximize    
  end
 
 
 
  def test_login
    @driver.find_element(:name, "username").send_keys "Admin"
    @driver.find_element(:name, "password").send_keys "Admin1234"
    @driver.find_element(:name, "commit").click
    sleep 0.3
    assert(@driver.find_element(:class => "user-name").text.include?("Admin"),"Assertion Failed")
  end
end