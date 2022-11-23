# frozen_string_literal: true

class Activity < ApplicationRecord
  has_many :bookmarks
  has_many :users, through: :bookmarks
  belongs_to :booking
  belongs_to :organizer
  belongs_to :category

  validates :name, :location, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :age_group, inclusion: { in: %w[0-2 3-5 6-9 10-12 13-17] }
end
