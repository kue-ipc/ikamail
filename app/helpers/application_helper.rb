# frozen_string_literal: true

module ApplicationHelper
  # def attr_scope
  #   @attr_scope ||= [:activerecord, :attributes, controller_name.singularize.intern]
  # end

  def controller_sym
    @controller_sym ||= controller_name.singularize.intern
  end

  def action_sym
    @action_sym ||= action_name.intern
  end

  # 翻訳系
  def t_model(model = controller_sym, count: 1)
    t(model, scope: [:activerecord, :models], count: count)
  end

  def t_title(title, model: controller_sym, count: 1)
    t(title, scope: [:titles], model: t_model(model, count: count))
  end

  def t_menu_action(attr, model:, count: 1)
    t(attr, scope: [:menu, :actions], model: t_model(model, count: count))
  end

  def t_attr(attr, model: controller_sym)
    t(attr, scope: [:activerecord, :attributes, model])
  end


  def menu_list
    list = []
    return list unless user_signed_in?
    if current_user.admin
      list << {
        path: admin_root_path,
        label: t(:admin_root, scope: [:menu, :paths]),
      }
    end
    list << {
      path: new_bulk_mail_path,
      label: t_menu_action(:new, model: :bulk_mail),
    }
    list << {
      path: bulk_mails_path,
      label: t_menu_action(:index, model: :bulk_mail, count: 2),
    }
    list << {
      path: bulk_mail_templates_path,
      label: t_menu_action(:index, model: :bulk_mail_template, count: 2),
    }
    list << {
      path: recipient_lists_path,
      label: t_menu_action(:index, model: :recipient_list, count: 2),
    }
  end
end
