class MessagesController < ApplicationController
    before_action :authenticate_user

    def index
        user = params[:user_id] ? User.find_by(id: params[:user_id]) : current_user

        if user != current_user
            return render json: { error: "Access denied" }, status: :forbidden
        end

        pagy, messages = pagy(Message.where(sender: user).or(Message.where(receiver: user)))

        pagination = {
            page: pagy.page,
            prev: pagy.prev,
            next: pagy.next,
            count: pagy.count,
            pages: pagy.pages
        }

        render json: {
            messages: messages.map { |message| serialize_message(message) },
            pagination: pagination
        }
    end

    def create
        message = Message.new(
            sender: current_user,
            receiver_id: params[:receiver_id],
            content: params[:content]
        )

        if params[:files].present?
            message.files.attach(params[:files])
        end

        if message.save
            MessageDeliveryJob.perform_later(message.id)
            render json: serialize_message(message), status: :created
        else
            render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def serialize_message(message)
        {
            id: message.id,
            sender_id: message.sender_id,
            sender: message.sender.username,
            receiver_id: message.receiver_id,
            receiver: message.receiver.username,
            content: message.content,
            files: message.files.map { |file| url_for(file) },
            created_at: message.created_at
        }
    end
end
