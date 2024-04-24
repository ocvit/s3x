# frozen_string_literal: true

require "rexml"
require "time"

module S3x
  class Bucket
    class Page
      URL = "%<bucket_url>s/?list-type=2&prefix=%<prefix>s&max-keys=%<page_size>s&start-after=%<after>s"

      attr_reader :bucket, :after

      def initialize(bucket, after: nil)
        @bucket = bucket
        @after = after
      end

      def url
        @url ||= URL % {
          bucket_url: bucket.url,
          prefix:     bucket.prefix,
          page_size:  bucket.page_size,
          after:      after&.[](:key)
        }
      end

      def name
        @name ||= parse_name
      end

      def items
        @items ||= parse_items
      end

      def truncated?
        @truncated ||= parse_truncated
      end

      private

      def xml
        @xml ||= begin
          xml_source = Http.get(url)
          REXML::Document.new(xml_source)
        end
      end

      def parse_name
        xml.get_text("//Name").to_s
      end

      def parse_items
        elements = xml.get_elements("//Contents")

        elements.map do |element|
          etag = element.get_text("ETag").to_s
          etag_normalized = etag.gsub!("&quot;", "")

          last_modified_string = element.get_text("LastModified").to_s
          last_modified = Time.parse(last_modified_string)

          {
            key:           element.get_text("Key").to_s,
            etag:          etag_normalized,
            size:          element.get_text("Size").to_s.to_i,
            storage_class: element.get_text("StorageClass").to_s,
            last_modified: last_modified
          }
        end
      end

      def parse_truncated
        xml.get_text("//IsTruncated") == "true"
      end
    end
  end
end
