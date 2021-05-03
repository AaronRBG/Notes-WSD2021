require "selenium-webdriver"
require "test/unit"


class NotestestClass < Test::Unit::TestCase
 
  def setup
    @driver = Selenium::WebDriver.for :chrome
    @driver.get('https://noteswsd2021.herokuapp.com/')
    @driver.manage.window.maximize   
    @driver.find_element(:name, "username").send_keys "Admin"
    @driver.find_element(:name, "password").send_keys "Admin1234" 
  end
 
 
 
  def test_deleteNote
    WebElement btnEliminar = driver.findElement(By.id("destroy"));

    btnEliminar.click();
  
    String expectedUrl = "https://sigetagibilibus.herokuapp.com/deleteAccount.html";
    String actualUrl = driver.getCurrentUrl();
    assertEquals(actualUrl, expectedUrl);
    
    WebElement opcion = driver.findElement(By.id("cause"));
    WebElement comentario = driver.findElement(By.id("comment"));
    
    comentario.sendKeys("No me funciona bien");
    opcion.click();
    opcion.sendKeys("Otro");
    
    WebElement btnRemove = driver.findElement(By.id("remove"));
    btnRemove.click();
  
    Alert alerta = driver.switchTo().alert();
    alerta.accept();
  end
end