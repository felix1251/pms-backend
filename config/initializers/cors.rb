Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:5173'
    resource '/api/v2/*',
      headers: :any,
      credentials: true,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end

  allow do
    origins 'app://.'
    resource '/api/v1/*',
      headers: :any,
      credentials: true,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end

  allow do
    origins 'app://.'
    resource '/api/admin/*',
      headers: :any, 
      redentials: true,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
