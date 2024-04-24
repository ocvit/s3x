# frozen_string_literal: true

RSpec::Matchers.define :be_etag do
  match do |actual|
    actual.is_a?(String) && actual.match?(/\A[0-9a-f]{32}(-\d+)?\z/)
  end
end
