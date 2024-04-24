# frozen_string_literal: true

module S3x
  class Bucket
    class FirstPageNotLoaded < StandardError
      def message
        "use #items first"
      end
    end

    DEFAULT_PAGE_SIZE = 1000

    attr_reader :url, :prefix, :page_size

    def initialize(url, prefix: nil, page_size: DEFAULT_PAGE_SIZE)
      @url = normalize_url(url)
      @prefix = prefix
      @page_size = page_size
    end

    def name
      page.name
    end

    def items
      page.items
    end

    def next_items
      raise FirstPageNotLoaded unless @page

      @page = next_page(page)
      items
    end

    def next_items?
      raise FirstPageNotLoaded unless @page

      page.truncated?
    end

    def all_items
      page = first_page
      all = [page.items]

      while page.truncated?
        page = next_page(page)
        all << page.items
      end

      all.flatten!
    end

    def download(item_key)
      item_url = "#{url}/#{item_key}"
      Http.get(item_url)
    end

    private

    def page
      @page ||= first_page
    end

    def first_page
      Page.new(self)
    end

    def next_page(page)
      Page.new(self, after: page.items.last)
    end

    def normalize_url(url)
      uri = URI(url)
      "#{uri.scheme}://#{uri.host}"
    end
  end
end
