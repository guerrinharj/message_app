class MessageDeliveryJob < ApplicationJob
    queue_as :default

    sidekiq_options retry: false # Ensure job runs only once

    def perform(sender_id, receiver_id, content)
        sender = User.find(sender_id)
        receiver = User.find(receiver_id)

        message = Message.create!(sender: sender, receiver: receiver, content: content)

        # Broadcast the message via WebSocket (ActionCable)
        ActionCable.server.broadcast("chat_#{receiver.id}", message.as_json)
    end
end
