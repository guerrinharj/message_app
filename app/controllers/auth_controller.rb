class AuthController < ApplicationController
    def login
        user = User.find_by(username: params[:username])
    
        if user && user.authenticate(params[:password])
            token = encode_token({ user_id: user.id })
            render json: { user: user, token: token }, status: :ok
        else
            render json: { error: "Invalid credentials" }, status: :unauthorized
        end
    end

    def signup
        user = User.new(user_params)
        if user.save
            token = encode_token({ user_id: user.id })
            render json: { user: user, token: token }, status: :created
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.permit(:username, :password)
    end

    def encode_token(payload)
        JWT.encode(payload, Rails.application.secret_key_base)
    end
end