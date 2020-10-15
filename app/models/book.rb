class Book < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :author, optional: true
  belongs_to :source, optional: true
  belongs_to :user, optional: true
end
