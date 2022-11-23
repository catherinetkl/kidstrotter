# This file should contain all the record creation needed to seed the database with its default values.
event_names = {
  "Nature" => ['Gardens by the Bay', 'Singapore Botanic Gardens', 'ORTO', 'Bollywood Farms', 'Water Play at Clusia Cove', "Jacob Ballas Children's Garden", 'Active Garden at Gardens by the Bay'],

  "Wildlife" => ['Singapore Zoo', 'Jurong Bird Park', 'S.E.A Aquarium','Jurong Frog Farm', 'Hay Diaries', 'Gallop Stable', 'The Live Turtle & Tortoise Museum'],

  "Indoor Playground" => ['Pororo Park Singapore', 'Superpark Singapore', 'Kiztopia Club', 'Superpark Singapore', 'Amazonia', 'The Artground', 'Airzone', 'Tayo Station', 'Bounce Singapore', 'NERF Action Xperience'],

  "Museuems and Exhibitions" => ['Singapore Discovery Centre', 'Science Centre Singapore', 'Lee Kong Chian Natural History Museum', 'Futre World - ArtScience Museum', 'Singapore Maritime Galley', 'Battlebox', 'Singapore Maritime Galley' 'National Galley Singapore', 'National Museum of Singapore'],

  "Outdoor Attractions" => ['Mud Krank', 'Fort Siloso Skywalk', 'Skyride at Skyliine Luge Sentosa', 'The Karting Arena', 'Coastal Playgrove at East Coast Park', 'Active Garden at Gardens by the Bay', 'Jubilee Park at Fort Canning', 'Jurassic Mile', 'Universal Studios', 'SkyHelix Sentosa']
}

puts %(Cleaning up database...)
Booking.destroy_all
Activity.destroy_all
Organizer.destroy_all
Category.destroy_all
User.destroy_all

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
pp "POPULATING CATEGORIES AND ACTIVITIES"
pp "==================="

event_names.keys.each do |category_name|
  category = Category.create!(name: category_name)
  pp "Created category with ID #{category.id}"

  event_names[category_name].each do |event_name|
    activity = Activity.create!(
      name: event_name,
      description: ['Lorem Ipsum'].sample,
      location: ['Northpoint'].sample,
      price: 50,
      age_group: '6-9',
      organizer: Organizer.all.sample,
      category: category
    )

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
