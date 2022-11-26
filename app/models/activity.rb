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
  has_many :google_images
  has_many :photos

  validates :name, :address, presence: true
  validates :adult_price, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :child_price, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :age_group, inclusion: { in: %w[0-2 3-5 6-9 10-12 13-17] }
  # validates :start_time, :end_time, presence: true

  pg_search_scope :search_by_activity,
                  against: %i[name],
                  # associated_against: { category: %i[name] },
                  using: { tsearch: { prefix: true } }

  # before_save :update_google_image_urls

  # TODO
  # has_attached :photo

  # def photo_url
  #   photo.attached? ? photo.path : google_image_url
  # end

  # <img src="#{photo_url}"

  def hero_image_url
    image_urls.first
  end

  def image_urls
    photos = []
    photos.present? ? photos : google_images.map(&:url)
  end

  # default_scope -> { order(:start_time) } # Our meetings will be ordered by their start_time by default

  def time
    "#{start_time.strftime('%I:%M %p')} - #{end_time.strftime('%I:%M %p')}"
  end
  # def fetch_google_image_urls
  #   thing = CGI.escape(name)
  #   url = URI("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{thing}&inputtype=textquery&fields=place_id%2Cformatted_address%2Cname%2Crating%2Cphotos%2Cgeometry&key=AIzaSyBblxAfyQjITHddg4IYMF77L-PHrfrLW4s")

  #   https = Net::HTTP.new(url.host, url.port)
  #   https.use_ssl = true
  #   request = Net::HTTP::Get.new(url)
  #   read_body = JSON.parse(https.request(request).read_body)

  #   test = read_body.dig("candidates")&.first&.dig("place_id")
  #   url_test = URI("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{test}&fields=name%2Cphotos%2Creviews&key=AIzaSyBblxAfyQjITHddg4IYMF77L-PHrfrLW4s")

  #   https = Net::HTTP.new(url_test.host, url_test.port)
  #   https.use_ssl = true
  #   request = Net::HTTP::Get.new(url_test)
  #   read_body = JSON.parse(https.request(request).read_body)

  #   read_body['result']["photos"].map do |photo|
  #     "https://maps.googleapis.com/maps/api/place/photo?maxwidth=2600&photoreference=#{photo["photo_reference"]}&key=AIzaSyBblxAfyQjITHddg4IYMF77L-PHrfrLW4s"
  #   end
  # end

  # private

  # def update_google_image_urls
  #   fetch_google_image_urls.each do |url|
  #     self.google_images << GoogleImage.create(url: url)
  #   end
  # end
end
