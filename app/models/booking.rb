# frozen_string_literal: true

class Booking < ApplicationRecord
  has_many :reviews
  belongs_to :activity
  belongs_to :user

  validates :status, presence: true
end
