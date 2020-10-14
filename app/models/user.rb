class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: {super_admin: :super_admin, admin: :admin, user: :user}

  def is_admin
    super_admin? || admin?
  end
end
