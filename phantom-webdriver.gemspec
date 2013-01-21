Gem::Specification.new do |s|
  s.name      = 'phantom-webdriver'
  s.version   = '1.0.0'
  s.date      = '2013-01-20'
  s.summary   = 'webwalker'
  s.description = ''
  s.authors   = ["Joanne Cheng"]
  s.email     = ['jcheng@absolute-performance.com']
  s.files     = ['lib/walker.rb', 'lib/actions.rb', 'lib/configuration.rb']

  s.add_dependency "selenium-webdriver"
  s.add_dependency "typhoeus"
  s.add_dependency "nokogiri"
  s.add_development_dependency "rspec"

end
