class User < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :activities, through: :bookings
  has_many :activities, through: :bookmarks
  # has_many :activities, through: :reviews
  # has_many :reviews
  has_many :bookings

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
