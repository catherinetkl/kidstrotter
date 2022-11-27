# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :activities

  def icon_image
    {
      'Nature' => 'forest-100.png',
      'Wildlife' => 'penguin-100.png',
      'Indoor Playground' => 'playground-100.png',
      'Museums and Exhibitions' => 'museum-100.png',
      'Outdoor Attractions' => 'theme-park-100.png'
    }[name]
  end
end
