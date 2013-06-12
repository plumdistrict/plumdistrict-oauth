require File.expand_path('../lib/plumdistrict-oauth/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency('rest-client', '>= 1.6.7')
  gem.required_ruby_version = '>= 1.9.1'
  gem.authors       = ["Bryan Reinhardt"]
  gem.email         = ["bryan.reinhardt@plumdistrict.com"]
  gem.description   = %q{An OAuth client library for user authentication to www.plumdistrict.com}
  gem.summary       = %q{An OAuth client library for user authentication to www.plumdistrict.com}
  gem.homepage      = "https://github.com/plumdistrict/plumdistrict-oauth"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.name          = "plumdistrict-oauth"
  gem.license       = 'MIT'
  gem.require_paths = ["lib"]
  gem.version       = PlumDistrict::OAuth::VERSION
end
