class Crawls::BaseService
  require "addressable/uri"

  attr_reader :source

  LIST_PAGINATION_SELECTOR = "ul.pagination li"
  ACTIVE_PAGINATION_SELECTOR = "ul.pagination li.active"
  DETAIL_PAGE_URL_SELECTOR = ".panel .panel-body .ebook h5 a"
  TITLE_SELECTOR = ".row.thong_tin_ebook .col-md-8 h5:nth-of-type(3)"
  AUTHOR_SELECTOR = ".row.thong_tin_ebook .col-md-8 h5:nth-of-type(2)"
  LINK_BOOKS_SELECTOR = ".row.thong_tin_ebook .col-md-8 a[target=_blank]"


  def initialize(source)
    @source = source
    @agent = Mechanize.new user_agent_alias: "Mac Safari"
  end

  def perform
    @total_crawl_objects = 0
    perform_crawl(source.url)
  end

  private

  def perform_crawl(url)
    page = @agent.get url
    detail_link_elements = page.search(DETAIL_PAGE_URL_SELECTOR)

    detail_link_elements.each do |link_element|
      link = link_element.attributes&.dig("href")&.value
      crawl_detail_page(@agent.get link)
    end

    next_page_url = find_next_paginate_url(page)
    # perform_crawl(next_page_url) if next_page_url.present?
  end

  def crawl_detail_page(page)
    title = page.at(TITLE_SELECTOR)
    author = page.at(AUTHOR_SELECTOR)
    book_links = page.search(LINK_BOOKS_SELECTOR)

    puts "#{title} || #{author} || #{book_links.first}"
  end

  def find_next_paginate_url(page)
    list_paginates = page.search(LIST_PAGINATION_SELECTOR)
    return nil if list_paginates.blank?

    current_paginate = page.at ACTIVE_PAGINATION_SELECTOR
    current_index = list_paginates.find_index(current_paginate)
    return nil if current_index.nil?

    next_paginate = list_paginates[current_index.to_i + 1]
    return nil if next_paginate.blank?

    # crawl_logger.info("\n crawling page: #{next_paginate&.text}")
    next_paginate.attributes["href"]&.value
  rescue StandardError => e
    puts "errors in next_paginate_url method"
    # log_error("errors in next_paginate_url method", e)
  end
end
