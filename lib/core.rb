# frozen_string_literal: true

# rubocop:disable Style/Lambda, Lint/MissingCopEnableDirective
# ------------------
# Converts hash to command array
#
# Example
#   {cargo: nil, build: nil, v: true, target: "wasm32-wasip2"}.then { Argvise.build _1 }
#   # Output => ["cargo", "build", "-v", "--target", "wasm32-wasip2"]
#
# Supported data structures:
# - Simple flags: `{ verbose: true }` => "--verbose"
# - Boolean values: `{ v: false }` => no argument generated
# - Array values: `{ tag: %w[a b] }` => `["--tag", "a", "--tag", "b"]`
# - Hash values: `{ label: { env: 'test' } }` => `["--label", "env=test"]`
class Argvise
  # Converts a hash into a command-line argument array
  #
  # @param options [Hash] The hash to be converted
  # @return [Array<String>] The generated array of command-line arguments
  #
  # sig { params(options: Hash).returns(T::Array[String]) }
  def self.build(options)
    new.build(options)
  end

  def build(options)
    # options.each_pair.flat_map { |k, v| process_pair(k.to_s, v) }
    options.each_with_object([]) do |(k, v), memo|
      memo.concat(process_pair(k.to_s, v))
    end
  end

  private

  # Processes a single key-value pair and generates the corresponding argument fragment
  def process_pair(key, value)
    # e.g., {cargo: nil, build: nil} => ["cargo", "build"]
    return [key] if value.nil?
    # e.g., {install: false} => []
    return [] unless value

    flag = build_flag(key)
    generate_args(flag, value)
  end

  # Builds the command-line flag prefix (automatically detects short or long options)
  #
  # short key, e.g., {v: true} => "-v"
  # long key, e.g., {verbose: true} => "--verbose"
  def build_flag(key)
    prefix = key.length == 1 ? '-' : '--'
    "#{prefix}#{key.tr('_', '-')}"
  end

  # Generates the corresponding argument array based on the value type
  def generate_args(flag, value)
    case value
    when true
      [flag]
    when Array
      expand_array(flag, value)
    when Hash
      expand_hash(flag, value)
    else
      # e.g., {tag: 'uuu'} => ["--tag", "uuu"]
      [flag, value.to_s]
    end
  end

  # {tag: ["v1", "v2"]}
  #   => (flag: "--tag", array: ['v1', 'v2'])
  #   =>  ["--tag", "v1", "--tag", "v2"]
  def expand_array(flag, array)
    # FP style: array.flat_map { |v| [flag, v.to_s] }
    array.each_with_object([]) do |v, memo|
      memo << flag
      memo << v.to_s
    end
  end

  # Processes hash values (generates key=value format)
  #
  # {label: { env: "test", key: "value" }}
  #   => (flag: "--label", hash)
  #   => ["--label", "env=test", "--label", "key=value"]
  def expand_hash(flag, hash)
    # hash.flat_map { |k, v| [flag, "#{k}=#{v}"] }
    hash.each_with_object([]) do |(k, v), memo|
      memo << flag
      memo << "#{k}=#{v}"
    end
  end
end

# A convenient lambda method: converts a hash into command-line arguments
#
# Example：
#   { v: true, path: '/path/to/dir' }.then(&hash_to_argv) # => ["-v", "--path", "/path/to/dir"]
#
# sig { returns(T.proc.params(options: Hash).returns(T::Array[String])) }
def hash_to_argv
  ->(options) do
    Argvise.build(options)
  end
end
