class Configuration
  def initialize(configuration_text)
    @document = Nokogiri::XML(configuration_text)
  end

  def steps
    @document.css('tbody > tr').map do |row|
      row.css('td').children.map { |td| td.text }
    end
  end

  def start
    @document.at_css('head > link').attributes['href'].text
  end

  def title
    @document.at_css('title').children.first.text
  end

end
