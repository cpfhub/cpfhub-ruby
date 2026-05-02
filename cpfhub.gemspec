Gem::Specification.new do |spec|
  spec.name          = "cpfhub"
  spec.version       = "1.0.0"
  spec.authors       = ["CPFHub.io"]
  spec.email         = ["contact@cpfhub.io"]

  spec.summary       = "Official Ruby SDK for CPFHub.io — Brazilian CPF lookup API."
  spec.description   = "Official Ruby SDK for CPFHub.io — Brazilian CPF lookup API. Get name, gender and date of birth from any CPF in ~300ms. Full LGPD compliance. Supports Rails, Sidekiq and plain Ruby."
  spec.homepage      = "https://cpfhub.io"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata = {
    "homepage_uri"    => "https://cpfhub.io",
    "source_code_uri" => "https://github.com/cpfhub/cpfhub-ruby",
    "changelog_uri"   => "https://github.com/cpfhub/cpfhub-ruby/blob/main/CHANGELOG.md",
    "documentation_uri" => "https://cpfhub.io/documentacao",
    "bug_tracker_uri" => "https://github.com/cpfhub/cpfhub-ruby/issues"
  }

  spec.files         = Dir["lib/**/*", "README.md", "LICENSE"]
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", ">= 2.0"
  spec.add_dependency "faraday-retry", ">= 2.0"
end
