# This file should contain all the record creation needed to seed the database with its default values.

event_names = {
  'Nature' => {
    'paid' => ['Gardens by the Bay', 'ORTO', 'Bollywood Farms', "Jacob Ballas Children's Garden"],
    'unpaid' => ['Singapore Botanic Gardens', 'Water Play at Clusia Cove']
  },

  'Wildlife' => {
    'paid' => ['Singapore Zoo', 'Jurong Bird Park', 'S.E.A Aquarium', 'Gallop Stable', 'The Live Turtle & Tortoise Museum'],
    'unpaid' => ['Jurong Frog Farm', 'Hay Dairies']
  },

  'Indoor Playground' => {
    'paid' => ['Pororo Park Singapore', 'Superpark Singapore', 'Kiztopia Club', 'Play by Kinderplay', 'Amazonia', 'NERF Action Xperience', 'Tayo Station'],
    'unpaid' => ['Paragon Playground', "PIP's Playbox", 'Marina Square Playground', 'Suntec City Playground', '313 Somerset Playground']
  },

  'Museums and Exhibitions' => {
    'paid' => ['Singapore Discovery Centre', 'Science Centre Singapore', 'Lee Kong Chian Natural History Museum', 'Future World - ArtScience Museum', 'Battlebox', 'National Gallery Singapore', 'National Museum of Singapore'],
    'unpaid' => ['Air Force Museum', 'Masak Masak - The Artground', 'Singapore Maritime Gallery']
  },

  'Outdoor Attractions' => {
    'paid' => ['Mud Krank', 'Skyride at Skyline Luge Sentosa', 'The Karting Arena', 'Universal Studios Singapore', 'SkyHelix Sentosa'],
    'unpaid' => ['Fort Siloso Skywalk', 'Coastal Playgrove at East Coast Park', 'Jurassic Mile', 'Jubilee Park at Fort Canning']
  }
}

filepath = 'lib/geometry.csv'
test_hash = {}

CSV.foreach(filepath) do |row|
  test_hash[row[0]] = [row[1], row[2], row[3]]
end

puts test_hash['ORTO']

puts %(Cleaning up database...)

puts %(Cleaning up bookings...)
Review.destroy_all
puts %(Cleaning up bookings...)
Booking.destroy_all
puts %(Cleaning up images...)
GoogleImage.destroy_all
puts %(Cleaning up bookmarks...)
Bookmark.destroy_all
puts %(Cleaning up activities...)
Activity.destroy_all
puts %(Cleaning up organizers...)
Organizer.destroy_all
puts %(Cleaning up categories...)
Category.destroy_all
puts %(Cleaning up users...)
User.destroy_all
puts %(Cleaning up age groups...)
AgeGroup.destroy_all

puts %(Database cleaned!)

pp "==================="
pp "POPULATING USERS AND ORGANISERS"
pp "==================="

3.times do
  attending_user = User.create!(
    first_name: Faker::Name.name,
    last_name: Faker::Name.name,
    email: Faker::Internet.email,
    password: 123_456
  )
  puts "User with id: #{attending_user.id} has been created"
end

organizing_user = User.create!(
  first_name: "Quinn",
  last_name: "Harley",
  email: 'admin@admin.com',
  password: 123_456
)
puts "User with id: #{organizing_user.id} has been created"

organizer = Organizer.create!(user: organizing_user)
puts "Organizer with id: #{organizer.id} has been created"


pp "==================="
pp "POPULATING AGE GROUPS"
pp "==================="


["Toddlers", "Children", "Teenagers"].each do |group|
  AgeGroup.create!(name: group)
  pp "Created age group (#{group})"
end


pp "==================="
pp "POPULATING CATEGORIES AND ACTIVITIES"
pp "==================="

event_names.keys.each do |category_name|
  category = Category.create!(name: category_name)
  pp "Created category with ID #{category.id}"

  ["paid", "unpaid"].each do |need_pay_or_not|
    pp "Creating #{need_pay_or_not} activities......"
    event_names[category_name][need_pay_or_not].each do |activity_name|

      pp "Trying to create Activity #{activity_name}"



    activity =
        Activity.create!(
          name: activity_name,
          description: ['Fun filled activities for everyone! Come here for a great time, and leave lasting fulfilled and wanting more!'].sample,
          address: test_hash[activity_name][0],
          require_booking: need_pay_or_not == 'paid',
          require_payment: need_pay_or_not == 'paid',
          adult_price: need_pay_or_not == 'paid' ? rand(35..90) : 0,
          child_price: need_pay_or_not == 'paid' ? rand(5..30) : 0,
          latitude: test_hash[activity_name][1],
          longitude: test_hash[activity_name][2],
          age_group: ['4-12', '4-9', '4-7'].sample,
          organizer: Organizer.all.sample,
          category: category
        )
        activity.age_groups << AgeGroup.all.sample

        puts "Activity with id: #{activity.id} has been created"
    end
  end
end

# pp "==================="
# pp "ADD IMAGES TO ACTIVITIES"
# pp "==================="

# rows = CSV.parse(File.read("lib/photos_patch.csv"))

# rows.each do |row|
#   pp row[0]
#   activity = Activity.find_by(name: row[0])
#   activity.google_images << GoogleImage.create(url: row[1])
#   activity.save!
# end

pp "==================="
pp "POPULATING BOOKINGS"
pp "==================="

all_activities = Activity.all

all_activities.each do |activity|
  attending_users = [activity.organizer.user_id]
  3.times do
    attending_user = User.where.not(id: attending_users).sample

    booking = Booking.create!(
      user_id: attending_user.id,
      activity: activity,
      status: "pending",
      start_time: Faker::Date.between(from: 2.days.from_now, to: 1.year.from_now).in_time_zone('Singapore')
    )
    puts "Booking with id: #{booking.id} has been created"

    attending_users << attending_user.id

  end
end


 #   thing = CGI.escape(event_name)
      #   url = URI("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{thing}&inputtype=textquery&fields=formatted_address%2Cname%2Crating%2Cphotos%2Cgeometry&region=sg&locationbias=circle:50000@1.3521,103.8198&key=AIzaSyBblxAfyQjITHddg4IYMF77L-PHrfrLW4s")

    #   https = Net::HTTP.new(url.host, url.port)
    #   https.use_ssl = true
    #   request = Net::HTTP::Get.new(url)
    #   read_body = JSON.parse(https.request(request).read_body)

    #   address = read_body.dig("candidates")&.first&.dig("formatted_address")
    #   lat = read_body.dig("candidates")&.first&.dig("geometry")&.dig('location')&.dig('lat')
    #   long = read_body.dig("candidates")&.first&.dig("geometry")&.dig('location')&.dig('lng')

    # pp "==================="
    # pp "ADD LOCATIONS TO ACTIVITIES"
    # pp "==================="

    # rows = CSV.parse(File.read("lib/geometry.csv"))

    # rows.each do |row|
    # end
