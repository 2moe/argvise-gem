# mruby-argvise

## Build mruby with argvise

To include the argvise gem in your mruby build, modify your build configuration file:

```ruby
# [MRUBY_DIR]/build_config/default.rb
#
MRuby::Build.new do |conf|
  # ...
  conf.gem github: '2moe/argvise-gem', branch: 'main', path: 'mruby', checksum_hash: 'c6be78fa86a7b19abbfb647cb7c2152a62e78ffd'
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
{tag: %w[v0 beta]}.then(&hash_to_argv)
#=> ["--tag", "v0", "--tag", "beta"]

Argvise.methods(false)
#=> [:new_proc, :build]

Argvise.instance_methods(false)
#=> [:with_bsd_style, :with_kebab_case_flags, :build, :bsd_style, :kebab_case_flags, :bsd_style=, :kebab_case_flags=]
```

3. [**more details**](../docs/Readme.md)
