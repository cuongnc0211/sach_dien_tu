class Crawls::BaseService
  require "addressable/uri"

  attr_reader :source, :user

  LIST_PAGINATION_SELECTOR = "ul.pagination li"
  ACTIVE_PAGINATION_SELECTOR = "ul.pagination li.active"
  DETAIL_PAGE_URL_SELECTOR = ".panel .panel-body .ebook h5 a"
  TITLE_SELECTOR = ".row.thong_tin_ebook .col-md-8 h1"
  CATEGORY_SELECTOR = ".row.thong_tin_ebook .col-md-8 h5:nth-of-type(2)"
  AUTHOR_SELECTOR = ".row.thong_tin_ebook .col-md-8 h5:nth-of-type(1)"
  LINK_BOOKS_SELECTOR = ".row.thong_tin_ebook .col-md-8 a[target=_blank]"
  THUMB_SELECTOR = ".thong_tin_ebook .col-md-4.cover img"
  DESCRIPTION_SELECTOR = ".gioi_thieu_sach"

  def initialize(source, user = User.find_by(email: 'sachdientu@bot.com'))
    @source = source
    @user = user
    @agent = Mechanize.new user_agent_alias: "Mac Safari"
    @authors = map_authors
    @categories = map_categories
    @logger = Logger.new(Rails.root.join("log/crawl/crawl_#{source.name}_at_#{Time.zone.now}"))
  end

  def perform
    @total_crawl_objects = 0
    perform_crawl(source.url)
  end

  private

  def perform_crawl(url)
    page = @agent.get url
    @logger.info("=======crawling page #{url}========")
    detail_link_elements = page.search(DETAIL_PAGE_URL_SELECTOR)

    detail_link_elements.each do |link_element|
      link = link_element.attributes&.dig("href")&.value
      @logger.info("---crawl detail page #{link}-----")
      crawl_detail_page(@agent.get link)
    end

    next_page_url = find_next_paginate_url(page)
    @logger.info("=======crawled page #{url}=========")
    @logger.info("")

    perform_crawl(next_page_url) if next_page_url.present?
  end

  def crawl_detail_page(page)
    title = page.at(TITLE_SELECTOR).text
    author_id = load_or_create_author(page.at(AUTHOR_SELECTOR)&.text)
    category_id = load_or_create_category(page.at(CATEGORY_SELECTOR)&.text)
    book_link_elements = page.search(LINK_BOOKS_SELECTOR)

    build_book_params(page, title, author_id, category_id, book_link_elements)
    @logger.info("#{title} || #{book_link_elements.first.text}")
  end

  def find_next_paginate_url(page)
    list_paginates = page.search(LIST_PAGINATION_SELECTOR)
    return nil if list_paginates.blank?

    current_paginate = page.at ACTIVE_PAGINATION_SELECTOR
    current_index = list_paginates.find_index(current_paginate)
    return nil if current_index.nil?

    next_paginate = list_paginates[current_index.to_i + 1]
    return nil if next_paginate.blank?

    next_paginate.at("a").attributes["href"]&.value
  rescue StandardError => e
    puts "errors in next_paginate_url method"
    @logger.info("errors in next_paginate_url method", e)
  end

  def map_authors
    Author.all.map {|a| [a.full_name.upcase, a.id]}.to_h
  end

  def map_categories
    Category.all.map {|c| [c.name.downcase, c.id]}.to_h
  end

  def load_or_create_author(full_name)
    return nil if full_name.blank?

    full_name = full_name.split(":")[1].upcase.strip
    if @authors[full_name].presence
      return @authors[full_name]
    else
      author = Author.create(full_name: full_name)
      @authors[full_name] = author
      return author.id
    end
  end

  def load_or_create_category(name)
    return nil if name.blank?

    name = name.split(":")[1].downcase.strip
    if @categories[name].presence
      return @categories[name]
    else
      category = Category.create(name: name)
      @categories[name] = category
      return category.id
    end
  end

  def build_book_params(page, title, author_id, category_id, book_link_elements)
    book_versions = {}
    book_link_elements.each_with_index do |bl, index|
      book_versions["#{index}"] = {file_type: bl.text, url: bl.attributes["href"]&.value}
    end

    book_params = {
      title: title,
      source_id: source.id,
      author_id: author_id,
      user_id: user.id,
      thumb_url: page.at(THUMB_SELECTOR).attributes["src"]&.value,
      description: page.at(DESCRIPTION_SELECTOR)&.text,
      category_id: category_id,
      book_versions_attributes: book_versions
    }
    Book.create book_params
  end
end
