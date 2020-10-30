class BookVersion < ApplicationRecord
  belongs_to :book

  delegate :title, :author_name, to: :book, prefix: false, allow_nil: true
end
