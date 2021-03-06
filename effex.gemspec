
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "effex/version"

Gem::Specification.new do |spec|
  spec.name          = "effex"
  spec.version       = Effex::VERSION
  spec.authors       = ["Chris Tierney"]
  spec.email         = ["notproperlycut@gmail.com"]

  spec.summary       = %q{Obtain FX rates from ECB feeds}
  spec.description   = %q{Your challenge for today is to delve deep into the work of foreign exchange (FX) to provide a
  Ruby library for obtaining FX rates.}
  spec.homepage      = ""

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "activesupport", "~> 5.2"
  spec.add_development_dependency "timecop", "~> 0.9"

  spec.add_dependency "activemodel", "~> 5.2"
  spec.add_dependency "validates_timeliness", "~> 4.0"
  spec.add_dependency "nokogiri", "~> 1.8"
  spec.add_dependency "sequel", "~> 5.14"
  spec.add_dependency "sqlite3", "~> 1.3"
  spec.add_dependency "pg", "~> 1.1"
end
