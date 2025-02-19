require 'faker'

puts "Seeding Users..."

# Create 5 sample users
5.times do
    User.create!(
        username: Faker::Internet.unique.username,
        password: "password123" # Default password for all users
    )
end

puts "✅ Users seeded!"

# Fetch first and last user
sender = User.first
receiver = User.last

# Ensure we have at least 2 users before creating a message
if sender && receiver && sender != receiver
    puts "Seeding Messages..."

    Message.create!(
        sender: sender,
        receiver: receiver,
        content: "Hello #{receiver.username}!"
    )

    puts "✅ Message seeded!"
else
    puts "⚠️ Not enough users to seed messages!"
end
