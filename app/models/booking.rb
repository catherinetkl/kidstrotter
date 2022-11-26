# frozen_string_literal: true

class Booking < ApplicationRecord
  has_many :reviews
  belongs_to :activity
  belongs_to :user

  validates :start_time, presence: true
  validates :status, presence: true
end
