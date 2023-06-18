module Authorizable
  extend ActiveSupport::Concern

  def authorizable_admin_user
    return if @current_user && @current_user.role.name == 'admin'

    render json: { error: 'you do not have permission to access this content.' }, status: :forbidden
  end
end
