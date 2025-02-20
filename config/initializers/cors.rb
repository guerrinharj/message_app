Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
        origins '*' # ✅ Allows ANY frontend to access the API

        resource '*',
                headers: :any,
                methods: [:get, :post, :put, :patch, :delete, :options, :head]
    end
end
