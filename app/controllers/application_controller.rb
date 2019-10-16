# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render text: exception, status: :internal_server_error
  end

  # rescue_from Pundit::NotAuthorizedError do |exception|
  #   pp exception
  #   # render text: exception, status: :forbidden
  #   # redirect_back(fallback_location: root_path)
  #   redirect_to recipient_lists_path
  # end

  before_action :authenticate_user!
  after_action :verify_authorized, unless: :devise_controller?
end
