class Book < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :author, optional: true
  belongs_to :source, optional: true
  belongs_to :user, optional: true
  has_many :book_versions, dependent: :destroy

  accepts_nested_attributes_for :book_versions, allow_destroy: true
end
