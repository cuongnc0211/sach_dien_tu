class Download::BookVersionsController < ApplicationController
  before_action :load_book_version, only: [:show]

  def show
  end

  private

  def load_book_version
    @book_version = BookVersion.find_by id: params[:id]
  end
end
