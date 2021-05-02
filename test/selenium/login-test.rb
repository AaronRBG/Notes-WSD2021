require "selenium-webdriver"
require "test/unit"


class LoginClass < Test::Unit::TestCase
 
  def setup
    Selenium::WebDriver::Chrome.driver_path = File.join(File.absolute_path('', File.dirname("C:\Users\Eli\OneDrive\Escritorio")),"Drivers","chromedriver.exe")
    @driver = Selenium::WebDriver.for :chrome
    @driver.get('localhost:3000')
    @driver.manage.window.maximize    
  end
 
 
  def teardown
    @driver.quit
  end
 
 
  def test_login
    @driver.find_element(:name, "username").send_keys "admin"
    @driver.find_element(:password, "password").send_keys "Admin1234"
    @driver.find_element(:id, "submit").click
    sleep 0.3
    assert(@driver.find_element(:id => "loggedin").text.include?("You Are Logged in"),"Assertion Failed")
    @driver.find_element(:id, "logout").click
  end
end