class AuthController < ApplicationController
    skip_before_action :authenticate_user, only: [:login, :signup]

    def login
        user = User.find_by(username: params[:username])

        if user && user.authenticate(params[:password])
            token = encode_token({ user_id: user.id })
            render json: { user: user.as_json(except: [:password_digest]), token: token }, status: :ok
        else
            render json: { error: "Invalid credentials" }, status: :unauthorized
        end
    end

    def signup
        user = User.new(user_params)

        if user.save
            token = encode_token({ user_id: user.id })
            render json: { user: user.as_json(except: [:password_digest]), token: token }, status: :created
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.permit(:username, :password)
    end
end
