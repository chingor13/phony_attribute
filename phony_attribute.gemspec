$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "phony_attribute/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "phony_attribute"
  s.version     = PhonyAttribute::VERSION
  s.authors     = ["Jeff Ching"]
  s.email       = ["ching.jeff@gmail.com"]
  s.homepage    = "http://github.com/chingor13/phony_attribute"
  s.summary     = "ActiveModel field serializer for handling phone numbers via Phony gem"
  s.description = "ActiveModel field serializer for handling phone numbers via Phony gem"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.2.0"
  s.add_dependency "phony", "~> 1.9.0"

  s.add_development_dependency "shoulda-context"
  s.add_development_dependency "sqlite3"
end
