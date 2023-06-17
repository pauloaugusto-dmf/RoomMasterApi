module RequestHelpers
  def headers_json
    { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
  end

  def authenticate_headers(user)
    token = Jwt::Encode.call(user)
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{token}"
    }
  end
end
