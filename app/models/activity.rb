# frozen_string_literal: true

class Activity < ApplicationRecord
  include PgSearch::Model

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  has_many :bookmarks
  has_many :users, through: :bookmarks
  has_many :bookings
  belongs_to :organizer
  belongs_to :category
  has_and_belongs_to_many :age_groups

  validates :name, :address, presence: true
  validates :adult_price, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :child_price, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :age_group, inclusion: { in: %w[0-2 3-5 6-9 10-12 13-17] }

  pg_search_scope :search_by_activity,
                  against: %i[name],
                  # associated_against: { category: %i[name] },
                  using: { tsearch: { prefix: true } }

  before_save :update_google_image_url

  # TODO
  # has_attached :photo

  # def photo_url
  #   photo.attached? ? photo.path : google_image_url
  # end

  # <img src="#{photo_url}"

  def image_url
    photo = nil
    photo ? photo : google_image_url
  end

  def fetch_google_image_urls
    thing = CGI.escape(name)
    url = URI("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{thing}&inputtype=textquery&fields=formatted_address%2Cname%2Crating%2Cphotos&key=AIzaSyBblxAfyQjITHddg4IYMF77L-PHrfrLW4s")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    read_body = JSON.parse(https.request(request).read_body)

    return nil unless read_body.dig("candidates")&.first&.dig("photos").present?

    read_body['candidates'].first["photos"].map do |photo|
      "https://maps.googleapis.com/maps/api/place/photo?maxwidth=2600&photoreference=#{photo["photo_reference"]}&key=AIzaSyBblxAfyQjITHddg4IYMF77L-PHrfrLW4s".to_sym
    end
  end

  private

  def update_google_image_url
    self.google_image_url ||= fetch_google_image_urls&.first
  end
end
