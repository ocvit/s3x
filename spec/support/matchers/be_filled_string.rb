# frozen_string_literal: true

RSpec::Matchers.define :be_filled_string do
  match do |actual|
    actual.is_a?(String) && !actual.empty?
  end
end
