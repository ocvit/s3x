# frozen_string_literal: true

require "net/http"

module S3x
  module Http
    RETRIABLE_ERRORS = [
      Errno::ECONNREFUSED,
      Errno::ECONNRESET,
      Errno::ETIMEDOUT,
      Net::OpenTimeout,
      Net::ReadTimeout,
      Net::WriteTimeout,
      OpenSSL::SSL::SSLError
    ].freeze

    MAX_RETRIES = 3

    def self.get(url, retries: 0)
      Net::HTTP.get(URI(url))
    rescue *RETRIABLE_ERRORS
      raise if retries > MAX_RETRIES

      get(url, retries: retries + 1)
    end
  end
end
