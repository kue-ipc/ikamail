class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render text: exception, status: :internal_server_error
  end

  before_action :authenticate_user!
  after_action :verify_authorized, unless: :devise_controller?

  def t_success_action(model, action)
    t("messages.success_action",
      model: model.model_name.human,
      action: t(action, scope: :actions))
  end

  def t_failure_action(model, action)
    t("messages.failure_action",
      model: model.model_name.human,
      action: t(action, scope: :actions))
  end
end
