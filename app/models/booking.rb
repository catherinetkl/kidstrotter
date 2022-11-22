class Booking < ApplicationRecord
  has_many :activities
  belongs_to :user

  validates :status, presence: true
end
