class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # relationships
  has_one :inn
  has_many :reservations
  has_many :reviews, through: :reservations

  # enums
  enum role: {regular: 0, host: 3, admin: 9}
end