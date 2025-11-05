#!/usr/bin/env ruby
# typed: ignore
# frozen_string_literal: true

# lib_path = File.expand_path('../lib', __dir__)
# exec "irb -I #{lib_path} -r argvise"

# require "bundler/setup"
# require "argvise"
require 'irb'
require_relative '../lib/argvise'

puts "Argvise: #{Argvise::VERSION}"

def puts_division_line
  puts
  puts '-' * 80
end

raw_cmd = {
  compiler: nil,
  build: nil,
  pack_type: 'tar+zstd',
  push: true,
  v: true,
  f: 'p2',
  tag: ['v0.0.1', 'beta'],
  platform: 'wasi/wasm',
  label: {
    maintainer: 'user',
    description: 'Demo'
  },
  "/path/to/dir": nil
}

puts 'GNU-style + kebab_case_flags(false)'
raw_cmd
  .then(&Argvise.new_proc)
  .with_bsd_style(false)
  .with_kebab_case_flags(false)
  .build
  .display

puts_division_line
# -----------

puts 'GNU-style + kebab_case_flags(true)'
raw_cmd
  .to_argv
  .display

puts_division_line
# -----------

puts 'BSD-style + kebab_case_flags(true)'
raw_cmd
  .then(&Argvise.new_proc)
  .with_bsd_style
  .with_kebab_case_flags
  .build
  .display

puts_division_line
# -----------

IRB.start
