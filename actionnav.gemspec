require_relative './lib/action_nav/version'
Gem::Specification.new do |s|
  s.name          = "actionnav"
  s.description   = %q{A navigation manager for Rails applications.}
  s.summary       = %q{This gem provides a friendly way to manage application navigation.}
  s.homepage      = "https://github.com/adamcooke/actionnav"
  s.version       = ActionNav::VERSION
  s.files         = Dir.glob("{lib}/**/*")
  s.require_paths = ["lib"]
  s.authors       = ["Adam Cooke"]
  s.email         = ["me@adamcooke.io"]
  s.licenses      = ['MIT']
  s.cert_chain    = ['certs/adamcooke.pem']
  s.signing_key   = File.expand_path("~/.ssh/gem-private_key.pem") if $0 =~ /gem\z/

  s.add_dependency "activesupport"
end
