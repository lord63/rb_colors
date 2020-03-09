# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rb_colors/version'

Gem::Specification.new do |spec|
  spec.name          = "rb_colors"
  spec.version       = RbColors::VERSION
  spec.authors       = ["lord63"]
  spec.email         = ["lord63.j@gmail.com"]

  spec.summary       = %q{Yet another library that deals with colors.}
  spec.description   = <<-EOF
    Convert colors between rgb, hsv and hex, perform arithmetic, blend modes,
	and generate random colors within boundaries.
  EOF
  spec.homepage      = "https://github.com/lord63/rb_colors"
  spec.license       = "BSD3"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 2.0.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest"
end
