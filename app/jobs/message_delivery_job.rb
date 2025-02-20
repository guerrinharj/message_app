class MessageDeliveryJob < ApplicationJob
    queue_as :default

    sidekiq_options retry: false

    def perform(message_id)
        message = Message.find(message_id)
        ActionCable.server.broadcast("chat_#{message.receiver_id}", serialize_message(message))
    end

    private

    def serialize_message(message)
        {
            id: message.id,
            sender_id: message.sender_id,
            receiver_id: message.receiver_id,
            content: message.content,
            files: message.files.map { |file| Rails.application.routes.url_helpers.url_for(file) },
            created_at: message.created_at
        }
    end
end

