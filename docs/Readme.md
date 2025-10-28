# Argvise

[![Gem Version](https://badge.fury.io/rb/argvise.svg?icon=si%3Arubygems)](https://rubygems.org/gems/argvise)

<!-- [![RubyDoc](https://img.shields.io/badge/-y?label=rubydoc&color=orange)](https://www.rubydoc.info/gems/argvise) -->

A Ruby gem for converting hash structures into command-line argument arrays.

> **Note:** This is *not* a command-line parser — quite the opposite. Argvise helps you **build** CLI commands programmatically.

## Quick Start

```ruby
# IRB
system "gem install argvise"
```

```ruby
# RUBY
require 'argvise'

{ cargo: nil, b: nil, r: true, target: "wasm32-wasip2" }
  .then(&hash_to_argv)

#=> ["cargo", "b", "-r", "--target", "wasm32-wasip2"]
```

`raw_cmd_hash.then(&hash_to_argv)` is equivalent to:

```ruby
{ cargo: nil, b: nil, r: true, target: "wasm32-wasip2" }
  .then(&Argvise.new_proc)
  .with_bsd_style(false) #=> GNU style
  .with_kebab_case_flags(true) #=> replace "--cli_flag" with "--cli-flag"
  .build
```

## Installation

### Ruby MRI

Add this line to your application's Gemfile:

```ruby
# Gemfile
#
gem 'argvise'
```

And then execute:

```sh
# SHELL
#
bundler install
```

Or install it directly:

```sh
# SHELL
#
gem install argvise
```

### mruby

[More details](../mruby/Readme.md)

## Conversion Rules

### Common

| Hash Format             | Result                       |
| ----------------------- | ---------------------------- |
| `{ "-k2": nil }`        | `["-k2"]`                    |
| `{ "--r_a-w_": nil }`   | `["--r_a-w_"]`               |
| `{ key: nil }`          | `["key"]`                    |
| `{ key: [] }`           | `[]`                         |
| `{ key: {} }`           | `[]`                         |
| `{ key: false }`        | `[]`                         |
| `{ k: true }`           | `["-k"]`                     |
| `{ k: "value" }`        | `["-k", "value"]`            |
| `{ k: ["a", "b"] }`     | `["-k", "a", "-k", "b"]`     |
| `{ k: { a: 1, b: 2 } }` | `["-k", "a=1", "-k", "b=2"]` |


### GNU Style

| Hash Format               | Result                             |
| ------------------------- | ---------------------------------- |
| `{ key: true }`           | `["--key"]`                        |
| `{ key: "value" }`        | `["--key", "value"]`               |
| `{ key: ["a", "b"] }`     | `["--key", "a", "--key", "b"]`     |
| `{ key: { a: 1, b: 2 } }` | `["--key", "a=1", "--key", "b=2"]` |

---

#### `with_kebab_case_flags(true)`:

| Hash Format       | Result        |
| ----------------- | ------------- |
| `{ key_a: true }` | `["--key-a"]` |

---

#### `with_kebab_case_flags(false)`:

| Hash Format       | Result        |
| ----------------- | ------------- |
| `{ key_b: true }` | `["--key_b"]` |


### BSD Style

| Hash Format               | Result                           |
| ------------------------- | -------------------------------- |
| `{ key: true }`           | `["-key"]`                       |
| `{ key: "value" }`        | `["-key", "value"]`              |
| `{ key: ["a", "b"] }`     | `["-key", "a", "-key", "b"]`     |
| `{ key: { a: 1, b: 2 } }` | `["-key", "a=1", "-key", "b=2"]` |

---

#### `with_kebab_case_flags(true)`:

| Hash Format       | Result       |
| ----------------- | ------------ |
| `{ key_c: true }` | `["-key-c"]` |

---

#### `with_kebab_case_flags(false)`:

| Hash Format       | Result       |
| ----------------- | ------------ |
| `{ key_d: true }` | `["-key_d"]` |


### Notes

> When the value of a flag key is `nil`, the `kebab_case_flags` option has
> no effect — i.e., the key will not be transformed.
>
> For example, the input `{"a_b-c": nil}` will result in `["a_b-c"]`,
> and **not** be automatically transformed into `["a-b-c"]`.

## Examples

### Basic Conversion (GNU Style)

```ruby
require 'argvise'

raw_cmd_hash = {
  docker: nil,  #=> docker
  build: nil,
  push: true, #=> --push
  tag: ["ghcr.io/[user]/repo:latest", "ghcr.io/[user]/repo:v0.0.1"], #=> --tag ghcr... --tag ghcr..0.0.1
  platform: "wasi/wasm", #=> --platform wasi/wasm
  label: {
    maintainer: "user",
    description: "A Docker build example"
  }, # => --label maintainer=user --label description=A..example
  file: "wasi.dockerfile",
  path: nil,
}

Argvise.build(raw_cmd_hash)
# => [
#   "docker", "build", "--push",
#   "--tag", "ghcr.io/[user]/repo:latest", "--tag", "ghcr.io/[user]/repo:v0.0.1",
#   "--platform", "wasi/wasm",
#   "--label", "maintainer=user", "--label", "description=A Docker build example",
#   "--file", "wasi.dockerfile", "path"
# ]
```

### Lambda Shortcut

```ruby
{ v: true, dir: '/path/to/dir' }.then(&hash_to_argv)
# => ["-v", "--dir", "/path/to/dir"]
```

### Configurable builder

> Required
>   - argvise: >= v0.0.4
>   - ruby: >= v3.1.0

```ruby
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

p '----------------'
p "GNU-style + kebab case flags=false"
raw_cmd
  .then(&Argvise.new_proc)
  .with_bsd_style(false)
  .with_kebab_case_flags(false)
  .build
  .display

#=> ["compiler", "build", "--pack_type", "tar+zstd", "--push", "-v", "-f", "p2", "--tag", "v0.0.1", "--tag", "beta", "--platform", "wasi/wasm", "--label", "maintainer=user", "--label", "description=Demo", "/path/to/dir"]

p '----------------'
p 'GNU-style + kebab-case-flags=true'
raw_cmd
  .then(&hash_to_argv)
  .display

#=> ["compiler", "build", "--pack-type", "tar+zstd", "--push", "-v", "-f", "p2", "--tag", "v0.0.1", "--tag", "beta", "--platform", "wasi/wasm", "--label", "maintainer=user", "--label", "description=Demo", "/path/to/dir"]

p '----------------'
p 'BSD-style + kebab-case-flags=true'
raw_cmd
  .then(&Argvise.new_proc)
  .with_bsd_style
  .with_kebab_case_flags
  .build
  .display

#=> ["compiler", "build", "-pack-type", "tar+zstd", "-push", "-v", "-f", "p2", "-tag", "v0.0.1", "-tag", "beta", "-platform", "wasi/wasm", "-label", "maintainer=user", "-label", "description=Demo", "/path/to/dir"]
```

## Data Type

### Boolean

#### GNU style

- `{ verbose: true }` => "--verbose"
- `{ v: true }` => "-v"
- `{ v: false }` => no argument generated

#### BSD style

- `{ verbose: true }` => "-verbose"
- `{ v: true }` => "-v"
- `{ v: false }` => no argument generated

### String

#### GNU style

- `{ f: "a.txt" }` => `["-f", "a.txt"]`
- `{ file: "a.txt" }` => `["--file", "a.txt"]`

#### BSD style

- `{ f: "a.txt" }` => `["-f", "a.txt"]`
- `{ file: "a.txt" }` => `["-file", "a.txt"]`

### Array

#### GNU style

- `{ t: ["a", "b"] }` => `["-t", "a", "-t", "b"]`
- `{ tag: %w[a b] }` => `["--tag", "a", "--tag", "b"]`

#### BSD style

- `{ t: ["a", "b"] }` => `["-t", "a", "-t", "b"]`
- `{ tag: %w[a b] }` => `["-tag", "a", "-tag", "b"]`

### Hash

#### GNU style

- `{ e: { profile: 'test', lang: 'C'} }` => `["-e", "profile=test", "-e", "lang=C"]`
- `{ env: { profile: 'test', lang: 'C'} }` => `["--env", "profile=test", "--env", "lang=C"]`

#### BSD style

- `{ e: { profile: 'test', lang: 'C'} }` => `["-e", "profile=test", "-e", "lang=C"]`
- `{ env: { profile: 'test', lang: 'C'} }` => `["-env", "profile=test", "-env", "lang=C"]`

## Nil => Raw

- `{ cargo: nil, b: nil}` => `["cargo", "b"]`
- `{ "-fv": nil}` => `["-fv"]`
