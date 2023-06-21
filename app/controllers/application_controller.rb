# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pagination
  include Authenticable
  include Authorizable
end
