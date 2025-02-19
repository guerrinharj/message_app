class MessagesController < ApplicationController
    def index
        pagy, messages = pagy(Message.all)

        pagination = {
            page: pagy.page,
            prev: pagy.prev,
            next: pagy.next,
            count: pagy.count,
            pages: pagy.pages,
        }

        render json: {
            messages: messages.as_json,
            pagination: pagination
        }
    end

    def create
        # Enqueue the Sidekiq job (instant execution)
        MessageDeliveryJob.perform_later(current_user.id, params[:receiver_id], params[:content])

        render json: { status: "Message is being processed asynchronously by Sidekiq" }, status: :accepted
    end
end
