class MetricsController < ApplicationController
    before_action :authenticate_user

    def index
        total_messages = Message.count
        active_users = User.joins("INNER JOIN messages ON users.id = messages.sender_id OR users.id = messages.receiver_id")
                        .distinct.count

        render json: {
            total_messages: total_messages,
            active_users: active_users
        }
    end
end
