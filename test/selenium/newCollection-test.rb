require "selenium-webdriver"
require "test/unit"


class Collection_Class < Test::Unit::TestCase
 
  def setup
    @driver = Selenium::WebDriver.for :chrome
    @driver.get('https://noteswsd2021.herokuapp.com/')
    
    @driver.manage.window.maximize    
  end
 
 
 
  def test_collection

    @driver.find_element(:name, "username").send_keys "Admin"
    @driver.find_element(:name, "password").send_keys "Admin1234"
    @driver.find_element(:name, "commit").click
    sleep 1

    #Se crea la coleccion
    @driver.get('https://noteswsd2021.herokuapp.com/notecollections/new')
    @driver.find_element(:name, "notecollection[name]").send_keys "Nueva coleccion Selenium"
    sleep 0.3

    @driver.find_element(:name, "commit").click
    sleep 2

    assert(@driver.find_element(:id => "table-index").text.include?("Nueva coleccion Selenium"),"Assertion Failed")


    sleep 1

    #Se añade nota a la coleccion
    @driver.get('https://noteswsd2021.herokuapp.com/notecollections/')
    @driver.find_element(:id, "btn3-index").click
    @driver.find_element(:id, "tr2-add").click
    sleep 0.3

    #Se comprueba el show notes viendo si se ha añadido la anterior nota
    @driver.get('https://noteswsd2021.herokuapp.com/notecollections/')
    @driver.find_element(:id, "btn2-index").click
    sleep 0.3

    assert(@driver.find_element(:id => "table-body-show").text.include?("Note 1"),"Assertion Failed")



  end



end