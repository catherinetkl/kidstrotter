# frozen_string_literal: true

class Booking < ApplicationRecord
  has_many :activities
  has_many :reviews
  belongs_to :user

  validates :status, presence: true
end
