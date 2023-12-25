# frozen_string_literal: true

require_relative "Lady/version"

module Lady
  class Error < StandardError; end

  autoload :Command,'Lady/command'
end

