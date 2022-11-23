# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts %(Cleaning up database...)
Activity.destroy_all
Organizer.destroy_all
Category.destroy_all
Booking.destroy_all
User.destroy_all

puts %(Database cleaned!)

3.times do
  new_user = User.create!(
    first_name: Faker::Name.name,
    last_name: Faker::Name.name,
    email: Faker::Internet.email,
    password: 123_456
  )
  puts "User with id: #{new_user.id} has been created"

  3.times do
    activity = Activity.create!(
      name: ['Beating up kids', 'Smashing Vases', 'Riding a tank', 'Live Firing at the Range', 'Bungee Jumping'].sample,
      description: ['Lorem Ipsum'],
      location: ['Northpoint'],
      price: 50,
      age_group: ['4']
    )
    puts "Activity with id: #{activity.id} has been created"
  end
end
