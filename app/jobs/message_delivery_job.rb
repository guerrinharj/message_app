class MessageDeliveryJob < ApplicationJob
    queue_as :messages

    def perform(sender_id, receiver_id, content)
        sender = User.find(sender_id)
        receiver = User.find(receiver_id)
    
        message = Message.create!(sender: sender, receiver: receiver, content: content)
    
        ChatChannel.broadcast_to("chat_#{receiver.id}", message.as_json)
    end
end