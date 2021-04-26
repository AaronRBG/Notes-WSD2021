class GoogleTest < Test::Unit::TestCase
    def setup
      @driver = Selenium::WebDriver.for :firefox
      @url = ""
      @driver.manage.timeouts.implicit_wait = 30
      
     end
    def test_google_search

      
     end


    def teardown
      @driver.quit
      
     end
    end