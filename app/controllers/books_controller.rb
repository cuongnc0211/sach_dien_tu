class BooksController < ApplicationController
  PER_PAGE = 20
  def index
  end

  def home
    @books = Book.includes(:book_versions, :author, :category).all
      .order(created_at: :desc).page(params[:page]).per(PER_PAGE)
  end
end
