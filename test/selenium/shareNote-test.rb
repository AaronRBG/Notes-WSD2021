require "selenium-webdriver"
require "test/unit"


class Share_Note_Class < Test::Unit::TestCase
 
  def setup
    @driver = Selenium::WebDriver.for :chrome
    @driver.get('https://noteswsd2021.herokuapp.com/')
    
    @driver.manage.window.maximize    
  end
 
 
 
  def test_shareNote

    @driver.find_element(:name, "username").send_keys "Maria"
    @driver.find_element(:name, "password").send_keys "Maria1234"
    @driver.find_element(:name, "commit").click
    sleep 1
    @driver.get('https://noteswsd2021.herokuapp.com/notes/new?user=Maria')
    @driver.find_element(:name, "note[title]").send_keys "Nueva nota para compartir"
    sleep 0.3
    @driver.find_element(:name, "note[text]").send_keys "Texto de la nota que voy a compartir con Elisa"
    sleep 0.3
    @driver.find_element(:name, "commit").click
    sleep 1
    assert(@driver.find_element(:xpath => "//table").text.include?("Nueva nota para compartir"),"Assertion Failed")
    
    table=@driver.find_element(:xpath => "//table")
    notes_count=table.all(:css, 'tr').size
    fila=@driver.find_elements(:xpath => "//table/tbody/tr")[notes_count-2]
    p(notes_count-2)
    fila.find_element(:link_text, "Share").click
    sleep 0.5
   filaUser=@driver.find_elements(:xpath => "//table/tbody/tr[5]/td")
  
   filaUser[1].click
 
   sleep 1
   @driver.get('https://noteswsd2021.herokuapp.com/')
   @driver.find_element(:name, "username").send_keys "Elisa"
   @driver.find_element(:name, "password").send_keys "Elisa1234"
   @driver.find_element(:name, "commit").click
   
   sleep 1
   assert(@driver.find_element(:xpath => "//table").text.include?("Nueva nota para compartir"),"Assertion Failed")
    
    sleep 0.5
  end
end