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
    fila.find_element(:id, "btn2-index").click
    sleep 1
    nota=@driver.find_elements(:xpath => "//table[@id='table-show']/tbody/tr")[0]
    assert(nota.find_element(:id => "td-show").text.include?(nombre),"Assertion Failed")



  end



end