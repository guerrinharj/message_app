class MessagesController < ApplicationController
    before_action :authenticate_user

    def index
        # Determine the user: either from params or default to the authenticated user
        user = params[:user_id] ? User.find_by(id: params[:user_id]) : current_user

        # Ensure the authenticated user can only access their own messages
        if user != current_user
            return render json: { error: "Access denied" }, status: :forbidden
        end

        # Fetch messages where the user is the sender or receiver
        pagy, messages = pagy(Message.where(sender: user).or(Message.where(receiver: user)))

        pagination = {
            page: pagy.page,
            prev: pagy.prev,
            next: pagy.next,
            count: pagy.count,
            pages: pagy.pages
        }

        render json: {
            messages: messages.as_json,
            pagination: pagination
        }
    end

    def create
        message = Message.create!(
            sender: current_user,
            receiver_id: params[:receiver_id],
            content: params[:content]
        )

        # Enqueue message processing in Sidekiq
        MessageDeliveryJob.perform_later(current_user.id, params[:receiver_id], params[:content])

        render json: { status: "Message is being processed asynchronously by Sidekiq" }, status: :accepted
    end
end
