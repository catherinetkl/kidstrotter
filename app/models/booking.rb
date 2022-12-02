# frozen_string_literal: true

class Booking < ApplicationRecord
  belongs_to :activity
  belongs_to :user

  validates :start_time, presence: true
  validates :status, presence: true
  has_many :reviews, dependent: :nullify

  STATUSES = %w[ Pending Booked Completed ]

end
