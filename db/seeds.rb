# This file should contain all the record creation needed to seed the database with its default values.

event_names = {
  'Nature' => {
    'paid' => ['Gardens by the Bay', 'ORTO', 'Bollywood Farms', "Jacob Ballas Children's Garden"],
    'unpaid' => ['Singapore Botanic Gardens', 'Water Play at Clusia Cove', 'Active Garden at Gardens by the Bay']
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
    'unpaid' => ['Fort Siloso Skywalk', 'Coastal Playgrove at East Coast Park', 'Active Garden at Gardens by the Bay', 'Jurassic Mile', 'Jubilee Park at Fort Canning']
  }
}

puts %(Cleaning up database...)
Booking.destroy_all
Activity.destroy_all
Organizer.destroy_all
Category.destroy_all
User.destroy_all
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

  organizing_user = User.create!(
    first_name: Faker::Name.name,
    last_name: Faker::Name.name,
    email: Faker::Internet.email,
    password: 123_456
  )
  puts "User with id: #{organizing_user.id} has been created"

  organizer = Organizer.create!(user: organizing_user)
  puts "Organizer with id: #{organizer.id} has been created"

end

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

  pp "Creating paid activities......"
  event_names[category_name]["paid"].each do |event_name|
    pp "Trying to create Activity #{event_name}"
    thing = CGI.escape(event_name)
    url = URI("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{thing}&inputtype=textquery&fields=formatted_address%2Cname%2Crating%2Cphotos%2Cgeometry&region=sg&locationbias=circle:50000@1.3521,103.8198&key=AIzaSyBblxAfyQjITHddg4IYMF77L-PHrfrLW4s")
    pp "Generated URL is #{url}"

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    read_body = JSON.parse(https.request(request).read_body)

    pp "google places api response is #{read_body}"

    address = read_body.dig("candidates")&.first&.dig("formatted_address")
    lat = read_body.dig("candidates")&.first&.dig("geometry")&.dig('location')&.dig('lat')
    long = read_body.dig("candidates")&.first&.dig("geometry")&.dig('location')&.dig('lng')

    activity =
      Activity.create!(
        name: event_name,
        description: ['Lorem Ipsum'].sample,
        address: address,
        require_booking: true,
        require_payment: true,
        adult_price: 50,
        child_price: 20,
        latitude: lat,
        longitude: long,
        age_group: '6-9',
        organizer: Organizer.all.sample,
        category: category,
      )

      activity.age_groups << AgeGroup.all.sample

      puts "Activity with id: #{activity.id} has been created"
  end

  pp "Creating unpaid activities......"
  event_names[category_name]["unpaid"].each do |event_name|
    pp "Trying to create Activity #{event_name}"
    thing = CGI.escape(event_name)
    url = URI("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{thing}&inputtype=textquery&fields=formatted_address%2Cname%2Crating%2Cphotos%2Cgeometry&region=sg&locationbias=circle:50000@1.3521,103.8198&key=AIzaSyBblxAfyQjITHddg4IYMF77L-PHrfrLW4s")
    pp "Generated URL is #{url}"

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    read_body = JSON.parse(https.request(request).read_body)

    pp "google places api response is #{read_body}"

    address = read_body.dig("candidates")&.first&.dig("formatted_address")
    lat = read_body.dig("candidates")&.first&.dig("geometry")&.dig('location')&.dig('lat')
    long = read_body.dig("candidates")&.first&.dig("geometry")&.dig('location')&.dig('lng')

    activity =
      Activity.create!(
        name: event_name,
        description: ['Lorem Ipsum'].sample,
        address: address,
        require_booking: false,
        require_payment: false,
        adult_price: 0,
        child_price: 0,
        latitude: lat,
        longitude: long,
        age_group: '6-9',
        organizer: Organizer.all.sample,
        category: category,
      )

      activity.age_groups << AgeGroup.all.sample

      puts "Activity with id: #{activity.id} has been created"
  end
end

pp "==================="
pp "POPULATING BOOKINGS"
pp "==================="

all_activities = Activity.all

all_activities.each do |activity|
  attending_users = [activity.organizer.user_id]
  3.times do
    attending_user = User.where.not(id: attending_users).sample

    booking = Booking.create(
      user_id: attending_user.id,
      activity: activity,
      status: "pending"
    )
    puts "Booking with id: #{booking.id} has been created"

    attending_users << attending_user.id
  end
end
