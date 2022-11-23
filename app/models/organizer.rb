# frozen_string_literal: true

class Organizer < ApplicationRecord
  has_many :activities
  belongs_to :user
end
