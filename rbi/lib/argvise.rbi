# typed: true
# frozen_string_literal: true

class Argvise
  class << self
    sig { params(options: Hash).returns(T::Array[String]) }
    def build(options); end
  end
end

sig { returns(T.proc.params(options: Hash).returns(T::Array[String])) }
def hash_to_args; end
