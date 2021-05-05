require "selenium-webdriver"
require "test/unit"


class Create_Note_Class < Test::Unit::TestCase
 
  def setup
    @driver = Selenium::WebDriver.for :chrome
    @driver.get('https://noteswsd2021.herokuapp.com/')
    
    @driver.manage.window.maximize    
  end
 
 
 
  def test_createNote

    @driver.find_element(:name, "username").send_keys "Admin"
    @driver.find_element(:name, "password").send_keys "Admin1234"
    @driver.find_element(:name, "commit").click
    sleep 1
    @driver.get('https://noteswsd2021.herokuapp.com/notes/new?user=Admin')
    @driver.find_element(:name, "note[title]").send_keys "Nueva Nota Selenium"
    sleep 0.3
    @driver.find_element(:name, "note[text]").send_keys "Texto de la nota que haremos"
    sleep 0.3
    @driver.find_element(:name, "commit").click
    sleep 1
    assert(@driver.find_element(:xpath => "//table").text.include?("Nueva Nota Selenium"),"Assertion Failed")
   
  end
end