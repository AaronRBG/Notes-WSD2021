require "selenium-webdriver"
require "test/unit"


class Collection_Class < Test::Unit::TestCase
 
  def setup
    @driver = Selenium::WebDriver.for :chrome
    @driver.get('https://noteswsd2021.herokuapp.com/')
    
    @driver.manage.window.maximize    
  end
 
 
 
  def test_collection

    @driver.find_element(:name, "username").send_keys "Diego"
    @driver.find_element(:name, "password").send_keys "Diego1234"
    @driver.find_element(:name, "commit").click
    sleep 1

    #Se crea la coleccion
    @driver.get('https://noteswsd2021.herokuapp.com/notecollections/new')
    @driver.find_element(:name, "notecollection[name]").send_keys "Nueva coleccion Diego"
    sleep 0.3

    @driver.find_element(:name, "commit").click
    sleep 2

    assert(@driver.find_element(:id => "table-index").text.include?("Nueva coleccion Diego"),"Assertion Failed")


    #Se añade nota a la coleccion de la ultima posicion que sera la que acabamos de añadir
    table=@driver.find_element(:id => "table-index")
    row_count=table.all(:css, 'tr').size
    fila=@driver.find_elements(:xpath => "//table[@id='table-index']/tbody/tr")[row_count-1]
    fila.find_element(:id, "btn3-index").click
    sleep 1
   
   
    #obtengo la primera fila donde estara la nota y el boton de añadir
    fila=@driver.find_elements(:xpath => "//table[@id='table-add']/tbody/tr")[1]
    #obtengo el nombre de la primera nota para luego comprobar si la añade bien
    nombre=fila.text.split("\n")[0]
    #añado la primera nota 
    fila.find_element(:id, "tr2-add").click
    sleep 1

   #Se comprueba el show notes viendo si se ha añadido la anterior nota
    fila=@driver.find_elements(:xpath => "//table[@id='table-index']/tbody/tr")[row_count-1]
    fila.find_element(:id, "btn1-index").click
    sleep 1
    alert = @driver.switch_to().alert()
    alert_text=alert.text


    assert(alert_text=="Are you sure?")
    alert.accept()
    sleep 1
    table2=@driver.find_element(:id => "table-index")
    row_count2=table2.all(:css, 'tr').size
  
    #compruebo que las filas que habia antes en la tabla se han visto reducidas
   assert(row_count>row_count2,"Assertion Failed")



  end



end