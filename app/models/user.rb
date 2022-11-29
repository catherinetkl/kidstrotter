# frozen_string_literal: true

class User < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :activities, through: :bookings
  has_many :activities, through: :bookmarks
  has_many :reviews
  has_many :bookings
  has_one :organizer

  has_one_attached :avatar
  acts_as_favoritor
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
