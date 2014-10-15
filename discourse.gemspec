$:.push File.expand_path("../lib", __FILE__)

# Describe your s.add_dependency and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "discourse"
  s.version     = "1.0"
  s.authors     = ["Discourse"]
  s.email       = [""]
  s.homepage    = ""
  s.summary     = "Discourse Forum as Mountable Engine"
  s.description = "A fork of the discourse forum intended for use as a mountable engine"

  #s.files = Dir["{app,config,db,lib}/**/*", "spec/factories/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails"
end
