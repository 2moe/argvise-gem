# mruby-argvise

## Build mruby with argvise

### Unix-Like OR Windows msys2

To include the argvise gem in your mruby build, modify your build configuration file:

```ruby
# [MRUBY_DIR]/build_config/default.rb
#
MRuby::Build.new do |conf|
  # ...
  conf.gem github: '2moe/argvise-gem', branch: 'main', path: 'mruby', checksum_hash: '24c4bc76715990d66ad0082315b6cd58438b0964'
  # ...
end
```

### Windows (native)

1. download and extract argvise-src

```ruby
# RUBY IRB
#
require 'open-uri'
require 'fileutils'
require 'pathname'

git_tag = 'v0.0.10'
url = "https://github.com/2moe/argvise-gem/archive/refs/tags/#{git_tag}.tar.gz"

target_dir = Pathname 'build/tmp/argvise'
output_file = target_dir.join 'argvise.tgz'
target_dir.mkpath

warn "Downloading ..."
URI.open(url)
  .then { IO.copy_stream(_1, output_file) }

Dir.chdir target_dir do |_|
  p `tar -xf #{output_file.basename.to_s}`
  File.rename "argvise-gem-#{git_tag.delete_prefix('v')}", 'gem'
  Dir.chdir 'gem/mruby'

  file = 'mrblib/argvise.rb'
  File.delete file
  FileUtils.cp '../lib/argvise/core.rb', file
end
```
<!--
NOTE:
v0.0.11
  file = 'mrblib/argvise.rb' => 'mrblib/00_core.rb'
-->

<!-- markdownlint-disable MD029 -->

2. modify your build conf

```ruby
# [MRUBY_DIR]/build_config/default.rb
#
MRuby::Build.new do |conf|
  # ...
  conf.gem 'build/tmp/argvise/gem/mruby'
  # ...
end
```

## Quick Start

1. **open `mirb`**

```sh
./build/host/bin/mirb
```

2. **try running**

```ruby
## Only required for v0.0.10 and below:
#   include Argvise::HashMixin

{tag: %w[v0 beta]}.to_argv
#=> ["--tag", "v0", "--tag", "beta"]

Argvise.methods(false)
#=> [:new_proc, :build]

Argvise.instance_methods(false)
#=> [:with_bsd_style, :with_kebab_case_flags, :build, :bsd_style, :kebab_case_flags, :bsd_style=, :kebab_case_flags=]
```
