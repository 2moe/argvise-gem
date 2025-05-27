#!/usr/bin/env ruby

require 'pathname'

Pathname(__dir__ || File.dirname(__FILE__))
  .parent
  .then { Dir.chdir(it) }

project = 'argvise'

puts `gem uninstall #{project}`
puts `gem build #{project}`
puts `gem install #{project}`
# gem push argvise-0.0.0.gem
