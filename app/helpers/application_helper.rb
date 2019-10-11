# frozen_string_literal: true

module ApplicationHelper
  def menu_list
    list = []
    return list unless user_signed_in?
    if current_user.admin
      list << {
        path: admin_root_path,
        label: t('menu.path.admin_root'),
      }
    end
    list << {
      path: new_bulk_mail_path,
      label: t('menu.action.new', name: t('activerecord.models.bulk_mail')),
    }
    list << {
      path: bulk_mails_path,
      label: t('menu.action.index', name: t('activerecord.models.bulk_mail', count: 2)),
    }
    list << {
      path: recipient_lists_path,
      label: t('menu.action.index', name: t('activerecord.models.recipient_list', count: 2)),
    }
    list << {
      path: bulk_mail_templates_path,
      label: t('menu.action.index', name: t('activerecord.models.bulk_mail_template', count: 2)),
    }
  end
end
