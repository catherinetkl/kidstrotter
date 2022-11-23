# frozen_string_literal: true

class Booking < ApplicationRecord
  belongs_to :activity
  has_many :reviews
  belongs_to :user

  validates :status, presence: true
end
