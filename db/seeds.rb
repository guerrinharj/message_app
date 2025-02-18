require 'faker'

puts "Seeding Users..."


5.times do
    User.create!(
        username: Faker::Internet.unique.username,
        password: "password123" 
    )
end

puts "✅ Seeding completed!"
