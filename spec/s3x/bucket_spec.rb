# frozen_string_literal: true

require "spec_helper"

RSpec.describe S3x::Bucket do
  let(:url) { "http://ftp.ruby-lang.org/?list-type=2&prefix=smth&others=" }

  describe ".new" do
    context "with default params" do
      subject(:bucket) { described_class.new(url) }

      it "assigns correct params" do
        expect(bucket).to have_attributes(
          url:       "http://ftp.ruby-lang.org",
          prefix:    nil,
          page_size: 1000
        )
      end
    end

    context "with custom params" do
      subject(:bucket) { described_class.new(url, prefix: "some/prefix", page_size: 1) }

      it "assigns correct params" do
        expect(bucket).to have_attributes(
          url:      "http://ftp.ruby-lang.org",
          prefix:   "some/prefix",
          page_size: 1
        )
      end
    end
  end

  describe "#name" do
    subject(:name) { bucket.name }

    let(:bucket) { described_class.new(url) }

    it "returns bucket name" do
      vcr("bucket/items") do
        expect(name).to eq "ftp.r-l.o"
      end
    end
  end

  describe "#items" do
    subject(:items) { bucket.items }

    context "when items found" do
      let(:bucket) { described_class.new(url) }

      it "returns list of items" do
        vcr("bucket/items") do
          expect(items.size).to eq 1000

          items.each do |item|
            expect_valid_item(item)
          end
        end
      end
    end

    context "when no items found" do
      let(:bucket) { described_class.new(url, prefix: "xyz") }

      it "returns an empty array" do
        vcr("bucket/no_items") do
          expect(items).to eq []
        end
      end
    end
  end

  describe "#next_items" do
    let(:bucket) { described_class.new(url, page_size: 5) }

    context "when first page is loaded" do
      it "returns list of next items" do
        vcr("bucket/next_items") do
          first_items = bucket.items
          next_items = bucket.next_items

          expect(next_items).not_to eq first_items
          expect(next_items.size).to eq 5

          next_items.each do |item|
            expect_valid_item(item)
          end
        end
      end
    end

    context "when first page is not loaded" do
      it "raises an error" do
        expect { bucket.next_items }.to raise_error(
          described_class::FirstPageNotLoaded,
          "use #items first"
        )
      end
    end
  end

  describe "#next_items?" do
    subject(:next_items?) { bucket.next_items? }

    context "when first page is loaded" do
      context "when next page present" do
        let(:bucket) { described_class.new(url) }

        it "returns true" do
          vcr("bucket/items") do
            bucket.items

            expect(next_items?).to eq true
          end
        end
      end

      context "when current page is the last one" do
        let(:bucket) { described_class.new(url, prefix: "pub/ruby/binaries") }

        it "returns false" do
          vcr("bucket/no_next_items") do
            bucket.items

            expect(next_items?).to eq false
          end
        end
      end
    end

    context "when first page is not loaded" do
      let(:bucket) { described_class.new(url) }

      it "raises an error" do
        expect { next_items? }.to raise_error(
          described_class::FirstPageNotLoaded,
          "use #items first"
        )
      end
    end
  end

  describe "#all_items" do
    subject(:all_items) { bucket.all_items }

    context "when items found" do
      let(:bucket) { described_class.new(url, prefix: "pub/ruby/binaries", page_size: 100) }

      it "returns list of all items" do
        vcr("bucket/all_items") do
          expect(all_items.size).to be > 500

          all_items.each do |item|
            expect_valid_item(item)
          end
        end
      end
    end

    context "when no items found" do
      let(:bucket) { described_class.new(url, prefix: "xyz") }

      it "returns an empty array" do
        vcr("bucket/no_items") do
          expect(all_items).to eq []
        end
      end
    end
  end

  describe "#download" do
    subject(:download) { bucket.download(item_key) }

    let(:bucket) { described_class.new(url) }
    let(:item_key) { "pub/misc/ci_versions/cruby-jruby.json" }

    it "downloads file and returns it" do
      vcr("bucket/download") do
        expect(download).to be_filled_string
      end
    end
  end

  def expect_valid_item(item)
    expect(item).to match(
      key:           be_path,
      etag:          be_etag,
      size:          be_a(Integer),
      storage_class: be_filled_string,
      last_modified: be_a(Time)
    )
  end
end
