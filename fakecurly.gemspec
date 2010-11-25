Gem::Specification.new do |gem|
  gem.name    = 'fakecurly'
  gem.version = '0.0.1'
  gem.date    = "2010-11-25"
  
  gem.summary = "Fakes *subset* of Recurly API"
  gem.description = "I use it for running tests on app that heavily relies on Recurly API"
 
  gem.authors  = ['Hubert Lepicki']
  gem.email    = 'hubert.lepicki@amberbit.com'
  gem.homepage = 'http://github.com/hubertlepicki/fakecurly'

  gem.files = Dir['{lib,spec}/**/*','README*', 'LICENSE*']
end
