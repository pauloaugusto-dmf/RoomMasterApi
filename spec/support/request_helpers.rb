module RequestHelpers
  def headers_json
    { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
  end
end
