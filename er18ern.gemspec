# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "er18ern/version"

Gem::Specification.new do |s|
  s.name        = "er18ern"
  s.version     = Er18Ern::VERSION
  s.authors     = ["Jacob & Others too ashamed to admit it"]
  s.email       = ["jacob@engineyard.com"]
  s.homepage    = "https://github.com/engineyard/er18ern"
  s.summary     = %q{i18n helpers}
  s.description = %q{i18n helpers (with ermahgerd)}

  s.files         = (`git ls-files`.split("\n") - `git ls-files -- fake`.split("\n"))
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "ermahgerd"
end
