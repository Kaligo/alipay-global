# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alipay_global/version'

Gem::Specification.new do |spec|
  spec.name          = "alipay_global"
  spec.version       = AlipayGlobal::VERSION
  spec.authors       = ["Melvrick Goh, Ng Junyang, Grzegorz Witek"]
  spec.email         = ["melvrickgoh@kaligo.com"]
  spec.description   = %q{An unofficial simple global.alipay gem}
  spec.summary       = %q{An unofficial simple global.alipay gem}
  spec.homepage      = "https://github.com/Kaligo/alipay-global.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "fakeweb"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "rest-client", "~> 1.8.0"

end
