module Actions
  class << self
    def open(step, driver)
      driver.navigate.to step[:target]
    end

    def clickAndWait(step, driver)
      puts 'clickAndWait'
    end

    def Total(step, driver)
    end
  end
end


