# frozen_string_literal: true

require_relative "lib/s3x/version"

Gem::Specification.new do |spec|
  spec.name = "s3x"
  spec.version = S3x::VERSION
  spec.authors = ["Dmytro Horoshko"]
  spec.email = ["electric.molfar@gmail.com"]

  spec.summary = "Scrape public AWS S3 buckets with ease"
  spec.description = "Scrape public AWS S3 buckets with ease."
  spec.homepage = "https://github.com/ocvit/s3x"
  spec.license = "MIT"
  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/ocvit/s3x/issues",
    "changelog_uri" => "https://github.com/ocvit/s3x/blob/main/CHANGELOG.md",
    "homepage_uri" => "https://github.com/ocvit/s3x",
    "source_code_uri" => "https://github.com/ocvit/s3x"
  }

  spec.files = Dir.glob("lib/**/*") + %w[README.md CHANGELOG.md LICENSE.txt]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.7"
end
