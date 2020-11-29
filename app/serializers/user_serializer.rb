class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar, :role, :created_at, :errors

  def errors
    object&.errors&.full_messages&.join(', ')
  end
end
