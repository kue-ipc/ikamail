class ApplicationController < ActionController::Base
  include Pundit::Authorization

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

  def t_success_action(model, action)
    t(:success_action,
      scope: [:messages],
      model: model.model_name.human,
      action: t(action, scope: :actions))
  end

  def t_failure_action(model, action)
    t(:failure_action,
      scope: [:messages],
      model: model.model_name.human,
      action: t(action, scope: :actions))
  end
end
