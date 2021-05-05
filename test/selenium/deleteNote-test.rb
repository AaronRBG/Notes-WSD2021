require "selenium-webdriver"
require "test/unit"


class Delete_Note_Class < Test::Unit::TestCase
     
    def setup
        @driver = Selenium::WebDriver.for :chrome
        @driver.get('https://noteswsd2021.herokuapp.com/')
        
        @driver.manage.window.maximize    
    end

    def test_deleteNote   
        @driver.find_element(:name, "username").send_keys "Admin"
        @driver.find_element(:name, "password").send_keys "Admin1234"
        @driver.find_element(:name, "commit").click

        @driver.find_element(:link_text, "Destroy").click


        sleep 0.3
        alert = @driver.switch_to().alert()
        alert_text=alert.text


        assert(alert_text=="Are you sure?")
        alert.accept()
    end

end