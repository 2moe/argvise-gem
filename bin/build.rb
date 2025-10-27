#!/usr/bin/env ruby
# typed: ignore
# frozen_string_literal: true

require 'pathname'

Pathname(__dir__ || File.dirname(__FILE__))
  .parent
  .then { Dir.chdir(it) }

proj = 'argvise'

system <<~CMD
  gem uninstall #{proj}
  gem build #{proj}
  gem install #{proj}
CMD

# gem push argvise-*.gem
