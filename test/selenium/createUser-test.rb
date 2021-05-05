require "selenium-webdriver"
require "test/unit"


class Create_User_Class < Test::Unit::TestCase
 
  def setup
    @driver = Selenium::WebDriver.for :chrome
    @driver.get('https://noteswsd2021.herokuapp.com/')
    
    @driver.manage.window.maximize    
  end
 
 
 
  def test_createUser

    @driver.find_element(:name, "username").send_keys "Admin"
    @driver.find_element(:name, "password").send_keys "Admin1234"
    @driver.find_element(:name, "commit").click
    sleep 1
    @driver.get('https://noteswsd2021.herokuapp.com/users/new')
    sleep 0.5
    @driver.find_element(:name, "user[username]").send_keys "UserSelenium"
    sleep 0.3
    @driver.find_element(:name, "user[name]").send_keys "Selenium"
    sleep 0.3
    @driver.find_element(:name, "user[email]").send_keys "Email_Selenium@gmail.com"
    sleep 0.3
    @driver.find_element(:name, "user[password]").send_keys "Selenium1234"
    sleep 0.3
    @driver.find_element(:name, "commit").click
    sleep 1
    @driver.find_element(:name, "username").send_keys "UserSelenium"
    sleep 0.3
    @driver.find_element(:name, "password").send_keys "Selenium1234"
    sleep 0.3
    @driver.find_element(:name, "commit").click
    sleep 1
    assert(@driver.find_element(:class => "user-name").text.include?("UserSelenium"),"Assertion Failed")
  end
end