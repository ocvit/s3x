# frozen_string_literal: true

require "spec_helper"

RSpec.describe S3x::Http do
  describe "#get" do
    subject(:get) { described_class.get(url) }

    let(:url) { "http://some.com" }

    context "when retriable error happens" do
      before do
        WebMock.disable_net_connect!(allow: /#{Regexp.escape(url)}/)
      end

      after do
        WebMock.disable_net_connect!
      end

      it "makes specified number of retries" do
        stub_request(:get, /#{Regexp.escape(url)}/).to_timeout

        expect(described_class).to receive(:get).exactly(5).and_call_original
        expect { get }.to raise_error(Net::OpenTimeout)
      end
    end

    context "when non-retriable error happens" do
      it "raises an error immidiately" do
        allow(Net::HTTP).to receive(:get).and_raise(StandardError, "Some error")

        expect(described_class).to receive(:get).once.and_call_original
        expect { get }.to raise_error(StandardError, "Some error")
      end
    end
  end
end
