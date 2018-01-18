# config: utf-8
lib = File.expand_path '../lib', __FILE__
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nrb/delivery_pick_list/version'

Gem::Specification.new do |s|

  s.name          = 'Gem to help with deliveries'
  s.version       = NRB::DeliveryPickList.version
  s.authors       = ["Dean Brundage"]
  s.email         = ["dean@newrepublicbrewing.com"]
  s.summary       = %q{Library used by New Republic Brewing Co}
  s.homepage      = "https://github.com/NewRepublicBrewing/quick-scripts/"
  s.license       = "GPL-3"

  s.bindir = 'bin'

  s.required_ruby_version = '>=2'

  s.add_runtime_dependency 'nrb-support'

  s.add_development_dependency "bundler"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"

  s.files = [
              'README.md',
              'LICENSE'
            ]

  s.require_paths = ['lib']

end
