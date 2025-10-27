# rubocop:disable Style/Documentation, Lint/MissingCopEnableDirective
# typed: true
# frozen_string_literal: true

class Argvise
  class << self
    sig do
      params(
        raw_cmd_hash: Hash,
        opts: T.nilable(T::Hash[Symbol, T::Boolean])
      ).returns(T::Array[String])
    end
    def build(raw_cmd_hash, opts: nil); end
  end

  sig do
    params(
      raw_cmd_hash: Hash,
      opts: T.nilable(T::Hash[Symbol, T::Boolean])
    ).void
  end
  def initialize(raw_cmd_hash, opts: nil); end

  sig { params(value: T::Boolean).returns(self) }
  def with_bsd_style(value = true); end # rubocop:disable Style/OptionalBooleanParameter

  sig { params(value: T::Boolean).returns(self) }
  def with_kebab_case_flags(value = true); end # rubocop:disable Style/OptionalBooleanParameter

  sig { returns(T::Array[String]) }
  def build; end
end

sig { returns(T.proc.params(raw_cmd_hash: T::Hash[T.any(Symbol, String), T.untyped]).returns(T::Array[String])) }
def hash_to_argv; end
