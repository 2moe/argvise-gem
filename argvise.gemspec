# frozen_string_literal: true

require_relative 'lib/argvise/version'

Gem::Specification.new do |spec|
  spec.name = 'argvise'
  # spec.version = '0.0.1'
  spec.version = Argvise::VERSION
  spec.authors = ['2moe']
  spec.email = ["m@tmoe.me"]

  spec.summary = 'Turns a hash into CLI arguments'
  spec.description = 'Provides flexible command-line argument generation with support for complex data structures'
  spec.license = 'Apache-2.0'
  # spec.extra_rdoc_files = ['docs/rdoc/Readme.rdoc']
  spec.required_ruby_version = '>= 3.0.0'
  # spec.metadata['allowed_push_host'] = "TODO: Set to your gem server 'https://example.com'"

  spec.homepage = 'https://github.com/2moe/argvise-gem'
  spec.metadata['homepage_uri'] = spec.homepage
  # spec.metadata['source_code_uri'] = spec.homepage
  # spec.metadata['changelog_uri'] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile Rakefile assets docs/Readme-zh-])
    end
  end
  # spec.bindir = 'exe'
  # spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
