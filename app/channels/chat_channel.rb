module ApplicationCable
  class ChatChannel < ApplicationCable::Channel
      def subscribed
          stream_from "chat_#{params[:user_id]}"
      end

      def receive(data)
          sender = User.find(data["sender_id"])
          receiver = User.find(data["receiver_id"])

          message = Message.create!(
              sender: sender,
              receiver: receiver,
              content: data["content"]
          )

          ActionCable.server.broadcast("chat_#{receiver.id}", message.as_json)
      end
  end
end
