# Argvise

[![Gem Version](https://badge.fury.io/rb/argvise.svg?icon=si%3Arubygems)](https://rubygems.org/gems/argvise)   [![RubyDoc](https://img.shields.io/badge/-y?label=rubydoc&color=orange)](https://www.rubydoc.info/gems/argvise)

A Ruby gem for converting hash structures into command-line argument arrays.

> **Note:** This is *not* a command-line parser — quite the opposite. Argvise helps you **build** CLI commands programmatically.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'argvise'
```

And then execute:

```bash
bundler install
```

Or install it directly:

```bash
gem install argvise
```

## Usage

### Basic Conversion

```ruby
require 'argvise'

options = { 
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

Argvise.build(options)
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
{ v: true, dir: '/path/to/dir' }.then(&hash_to_args)
# => ["-v", "--dir", "/path/to/dir"]
```

## Supported Data Structures

### 1. Simple Flags

```ruby
{ verbose: true }.then(&hash_to_args)  # => ["--verbose"]
```

### 2. Boolean Values

```ruby
{ silent: false }.then(&hash_to_args) # => []
```

### 3. Array Values

```ruby
{ tag: %w[a b] }.then(&hash_to_args)
# => ["--tag", "a", "--tag", "b"]
```

### 4. Hash Values

```ruby
{ label: { env: 'test', k2: 'v2' } }.then(&hash_to_args)
# => ["--label", "env=test", "--label", "k2=v2"]
```

## API Documentation

### `Argvise.build(options)`

Main method to convert hash to command-line arguments array

**Parameters:**

- `options` (Hash) - The hash to be converted

**Returns:**

- Array<String> generated command-line arguments

### Conversion Rules

| Hash Format               | Result Example                     |
| ------------------------- | ---------------------------------- |
| `{ key: nil }`            | `["key"]`                          |
| `{ key: false }`          | `[]`                               |
| `{ key: true }`           | `["--key"]`                        |
| `{ k: true }`             | `["-k"]`                           |
| `{ key: "value" }`        | `["--key", "value"]`               |
| `{ key: ["a", "b"] }`     | `["--key", "a", "--key", "b"]`     |
| `{ key: { a: 1, b: 2 } }` | `["--key", "a=1", "--key", "b=2"]` |
