# frozen_string_literal: true

require "vcr"

DEFAULT_CASSETTE_OPTS = {
  match_requests_on: [:uri, :method, :body, :headers],
  allow_unused_http_interactions: false
}

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/vcr"
  c.hook_into :webmock
end

if ENV["NO_VCR"]
  VCR.turn_off!(ignore_cassettes: true)
end

def vcr(path, opts = {})
  WebMock.allow_net_connect! if ENV["NO_VCR"]

  VCR.use_cassette(path, DEFAULT_CASSETTE_OPTS.merge(opts)) do
    yield
  end
end
