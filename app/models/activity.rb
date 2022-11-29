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
  has_one_attached :photo
  # has_many :google_images
  acts_as_favoritable

  validates :name, :address, presence: true
  validates :adult_price, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :child_price, numericality: { greater_than_or_equal_to: 0 }, presence: true

  pg_search_scope :search_by_activity_and_category,
                  against: %i[name],
                  associated_against: { category: %i[name] },
                  using: { tsearch: { prefix: true } }

  # before_save :update_google_image_urls

  # TODO
  # has_attached :photo

  # def photo_url
  #   photo.attached? ? photo.path : card_image
  # end

  # <img src="#{photo_url}"

  def hero_image_url
    image_urls.first
  end

  def card_image
    { 'Gardens by the Bay' => "Activities/Nature/Gardens by the Bay/_DSC9043.jpg",
      'ORTO' => "Activities/Nature/ORTO/2021-09-28.jpg",
      'Bollywood Farms' => "Activities/Nature/Bollywood Farms/IMG_20190419_093439.jpg",
      "Jacob Ballas Children's Garden" => "Activities/Nature/Jacob Ballas Children's Garden/2021-12-04.jpg",
      'Singapore Botanic Gardens' => "Activities/Nature/Singapore Botanic Gardens/20221027_131105.jpg",
      'Water Play at Clusia Cove' => "Activities/Nature/Water Play at Clusia Cove/2020-03-19.jpg",
      'Singapore Zoo' => "Activities/Wildlife/Singapore Zoo/2021-06-24.jpg",
      'Jurong Bird Park' => "Activities/Wildlife/Jurong Bird Park/2022-08-03.jpg",
      'S.E.A Aquarium' => "Activities/Wildlife/S.E.A Aquarium/SEAA_OOT_3Kids_Layered double Lighten.jpg",
      'Gallop Stable' => "Activities/Wildlife/Gallop Stable/2022-08-06.jpg",
      'The Live Turtle & Tortoise Museum' => "Activities/Wildlife/The Live Turtle & Tortoise Museum/20220711_143804.jpg",
      'Jurong Frog Farm' => "Activities/Wildlife/Jurong Frog Farm/2021-11-28.jpg",
      'Hay Dairies' => "Activities/Wildlife/Hay Dairies/2022-04-01.jpg",
      'Pororo Park Singapore' => "Activities/Indoor Playground/Pororo Park Singapore/2021-01-13.jpg",
      'Superpark Singapore' => "Activities/Indoor Playground/Superpark Singapore/2021-12-12.jpg",
      'Kiztopia Club' => "Activities/Indoor Playground/Kiztopia Club/20210616-Kiztopia-ClubJP-0388_WEB.jpg",
      'Play by Kinderplay' => "Activities/Indoor Playground/Play by Kinderplay/2022-11-09.jpg",
      'Amazonia' => "Activities/Indoor Playground/Amazonia/The Team.jpg",
      'NERF Action Xperience' => "Activities/Indoor Playground/NERF Action Xperience/20190924_NAX_INTERIOR_006.jpg",
      'Tayo Station' => "Activities/Indoor Playground/Tayo Station/NNM_3052.JPG",
      'Paragon Playground' => "Activities/Indoor Playground/Paragon Playground/2018-05-15.jpg",
      "PIP's Playbox" => "Activities/Indoor Playground/PIP's Playbox/IMG_20210821_150839.jpg",
      'Marina Square Playground' => "Activities/Indoor Playground/Marina Square Playground/2019-08-06.jpg",
      'Suntec City Playground' => "Activities/Indoor Playground/Suntec City Playground/Suntec-City-Playground-p-1080.jpg",
      'Singapore Discovery Centre' => "Activities/Museums and Exhibitions/Singapore Discovery Centre/Photo Op at Concourse.jpg",
      '313 Somerset Playground' => "Activities/Indoor Playground/313 Somerset Playground/2022-09-04.jpg",
      'Science Centre Singapore' => "Activities/Museums and Exhibitions/Science Centre Singapore/IMG_20190601_152554.jpg",
      'Lee Kong Chian Natural History Museum' => "Activities/Museums and Exhibitions/Lee Kong Chian Natural History Museum/2022-02-02.jpg",
      'Future World - ArtScience Museum' => "Activities/Museums and Exhibitions/Future World - ArtScience Museum/2019-06-30.jpg",
      'Battlebox' => "Activities/Museums and Exhibitions/Battlebox/IMG_20220903_091809.jpg",
      'National Gallery Singapore' => "Activities/Museums and Exhibitions/National Gallery Singapore/PXL_20220721_041221718.jpg",
      'National Museum of Singapore' => "Activities/Museums and Exhibitions/National Museum of Singapore/2022-10-06.jpg",
      'Air Force Museum' => "Activities/Museums and Exhibitions/Air Force Museum/2018-03-21.jpg",
      'Masak Masak - The Artground' => "Activities/Museums and Exhibitions/Masak Masak - The Artground/IMG_20190813_154451.jpg",
      'Singapore Maritime Gallery' => "Activities/Museums and Exhibitions/Singapore Maritime Gallery/mpa-7834.jpg",
      'Mud Krank' => "Activities/Outdoor Attractions/Mud Krank/20200327_103322.jpg",
      'Skyride at Skyline Luge Sentosa' => "Activities/Outdoor Attractions/Skyride at Skyline Luge Sentosa/IMG_E9638.JPG",
      'The Karting Arena' => "Activities/Outdoor Attractions/The Karting Arena/2019-01-12.jpg",
      'Universal Studios Singapore' => "Activities/Outdoor Attractions/Universal Studios Singapore/IMG_20220704_113421.jpg",
      'SkyHelix Sentosa' => "Activities/Outdoor Attractions/SkyHelix Sentosa/20220416_192119.jpg",
      'Fort Siloso Skywalk' => "Activities/Outdoor Attractions/Fort Siloso Skywalk/2021-12-27.jpg",
      'Coastal Playgrove at East Coast Park' => "Activities/Outdoor Attractions/Coastal Playgrove at East Coast Park/2021-04-09.jpg",
      'Jurassic Mile' => "Activities/Outdoor Attractions/Jurassic Mile/20220314_101946.jpg",
      'Jubilee Park at Fort Canning' => "Activities/Outdoor Attractions/Jubilee Park at Fort Canning/2019-07-07.jpg" }[name]
  end

  # def image_urls
  #   photos = []
  #   photos.present? ? photos : google_images.map(&:url)
  # end

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
