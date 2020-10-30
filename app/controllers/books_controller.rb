class BooksController < ApplicationController
  before_action :load_book, only: [:show]

  PER_PAGE = 20

  def index
  end

  def home
    @books = Book.includes(:book_versions, :author, :category).all
      .order(created_at: :desc).page(params[:page]).per(PER_PAGE)
    @is_root = true
  end

  def show
  end

  private

  def load_book
    @book = Book.includes(:category, :author, :source, :user, :book_versions).find_by id: params[:id]
  end
end
