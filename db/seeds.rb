# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "create admin"

admin = User.create(email: ENV["ADMIN_EMAIL"], password: ENV["ADMIN_PASS"], role: :super_admin, name: "Super Admin")

puts "create bot"

bot = User.create(email: 'sachdientu@bot.com', password: '123123', role: :user, name: 'Sach Dien Tu')

puts "create users"
10.times do |n|
  User.create(email: "user_#{n + 1}@gmail.com", password: '123123', role: :user, name: "User_#{n+1}")
end
