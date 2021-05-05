require "selenium-webdriver"
require "test/unit"


class Collection_Share_Class < Test::Unit::TestCase
 
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
    sleep 0.5
   
   
    #obtengo la primera fila donde estara la nota y el boton de añadir
    fila=@driver.find_elements(:xpath => "//table[@id='table-add']/tbody/tr")[2]
    #obtengo el nombre de la primera nota para luego comprobar si la añade bien
    nombre=fila.text.split("\n")[0]
    #añado la primera nota 
    fila.find_element(:id, "tr2-add").click
    sleep 1

    #ahora la comparto
    fila=@driver.find_elements(:xpath => "//table[@id='table-index']/tbody/tr")[row_count-1]
    collectionShared=fila.text.split("\n")[0]
    fila.find_element(:id, "btn4-index").click
    sleep 1
    filaUser=@driver.find_elements(:xpath => "//table[@id='table-share']/tbody/tr")[4]
    filaUser.find_element(:id, "td4-share").click
    #assert(nota.find_element(:id => "td-show").text.include?(nombre),"Assertion Failed")
    sleep 0.5
   
    @driver.get('https://noteswsd2021.herokuapp.com/logout')
    sleep 1
    @driver.get('https://noteswsd2021.herokuapp.com')
    sleep 0.5
    @driver.find_element(:name, "username").send_keys "Maria"
    @driver.find_element(:name, "password").send_keys "Maria1234"
    sleep 0.3
    @driver.find_element(:name, "commit").click
    sleep 0.4
    @driver.get('https://noteswsd2021.herokuapp.com/notecollectionsUser?user=Maria')
    sleep 1
    #ahora la busco para el asserts
  
    assert(@driver.find_element(:id => "table-index").text.include?(collectionShared),"Assertion Failed")
    
    
  end



end