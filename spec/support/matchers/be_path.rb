# frozen_string_literal: true

RSpec::Matchers.define :be_path do
  match do |actual|
    actual.is_a?(String) && URI(actual).path == actual
  end
end
