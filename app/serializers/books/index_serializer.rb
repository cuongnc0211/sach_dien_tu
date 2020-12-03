class Books::IndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :publish_date, :thumb_url, :created_at

  has_one :source
  has_one :author
  has_one :category
end
