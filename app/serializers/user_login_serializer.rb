class UserLoginSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar, :role, :created_at, :authen_token

  def authen_token
    Auth.issue({id: object.id})
  end
end