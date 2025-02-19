class ApplicationController < ActionController::API
    include Pagy::Backend
    before_action :authenticate_user

    private

    def authenticate_user
        token = extract_token_from_header
    
        if token
            begin
            decoded_token = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')
            user_id = decoded_token[0]['user_id']
            @current_user = User.find(user_id)
            rescue JWT::DecodeError, ActiveRecord::RecordNotFound
            render json: { error: 'Invalid or expired token' }, status: :unauthorized
            end
        else
            render json: { error: 'Authorization token missing' }, status: :unauthorized
        end
    end

    def current_user
        @current_user
    end

    def encode_token(payload)
        JWT.encode(payload, Rails.application.secret_key_base)
    end

    def extract_token_from_header
        auth_header = request.headers['Authorization']
        return unless auth_header&.start_with?('Bearer ')
    
        auth_header.split(' ').last
    end
end
