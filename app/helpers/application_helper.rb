# frozen_string_literal: true

module ApplicationHelper
  def controller_sym
    controller_name.singularize.intern
  end

  def action_sym
    action_name.intern
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

    if current_user.admin?
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
      path: templates_path,
      label: t_menu_action(:index, model: :template, count: 2),
    }
    list << {
      path: recipient_lists_path,
      label: t_menu_action(:index, model: :recipient_list, count: 2),
    }
    if current_user.admin?
      list << {
        path: mail_users_path,
        label: t_menu_action(:index, model: :mail_user, count: 2),
      }
      list << {
        path: mail_groups_path,
        label: t_menu_action(:index, model: :mail_group, count: 2),
      }
    end
    list
  end

  def dt_dd_tag(term, &block)
    content_tag('div', class: 'row border-bottom mb-2 pb-2') do
      content_tag('dt', term, class: 'col-sm-6 col-md-4 col-xl-2 col-print-full') +
        content_tag('dd', class: 'col-sm-6 col-md-8 col-xl-10  col-print-full mb-0', &block)
    end
  end

  def dt_dd_for(recored, attr, **opts)
    if block_given?
      dt_dd_tag recored.class.human_attribute_name(attr) do
        yield recored.__send__(attr)
      end
    else
      dt_dd_for(recored, attr, opts) do |value|
        span_value_for(value, **opts)
      end
    end
  end

  def span_value_for(value, **opts)
    case value
    when nil
      content_tag('span', opts[:blank_alt] || t(:none, scope: :values), class: 'font-italic text-muted')
    when '', [], {}
      content_tag('span', opts[:blank_alt] || t(:empty, scope: :values), class: 'font-italic text-muted')
    when String
      case opts[:format]
      when :mail_body
        mail_body_tag(value, **opts)
      when :translate
        span_text_tag(t(value, scope: opts[:scope]), **opts)
      else
        span_text_tag(value, **opts)
      end
    when Time, Date, DateTime, ActiveSupport::TimeWithZone
      content_tag('span', l(value, format: opts[:format]))
    when true, false
      if value
        icon('toggle-on')
      else
        icon('toggle-off')
      end
    when Enumerable
      content_tag('ul', class: 'list-inline mb-0') do
        list_html = sanitize('')
        value.each do |v|
          list_html += content_tag('li', class: 'list-inline-item border border-primary rounded px-1 mb-1') do
            span_value_for(v, **opts)
          end
        end
        list_html
      end
    when BulkMail, MailGroup, MailUser, RecipientList, Template
      link_to(value.to_s, value)
    else
      content_tag('span', value.to_s, class: '')
    end
  end

  def mail_body_tag(value, **opts)
    content_tag('pre', value, class: 'border rounded mb-0 mail-body line-76-80') do
      span_text_tag(value, **opts)
    end
  end

  def span_text_tag(value, around: nil, **_)
    if around.present?
      content_tag('span', around[0], class: 'text-muted') +
        content_tag('span', value) +
        content_tag('span', around[1], class: 'text-muted')
    else
      content_tag('span', value)
    end
  end

  def html_month(time)
    time.strftime('%Y-%m')
  end

  def html_date(time)
    time.strftime('%Y-%m-%d')
  end

  def html_time(time, second: true)
    if second
      time.strftime('%H:%M:%S')
    else
      time.strftime('%H:%M')
    end
  end

  def html_datetime_local(time, second: true)
    if second
      time.strftime('%Y-%m-%dT%H:%M:%S')
    else
      time.strftime('%Y-%m-%dT%H:%M')
    end
  end

  def html_datetime_zone(time)
    time.xmlschema
  end

  def icon(name, size: 24, **opts)
    opts = {width: size, height: size, fill: 'currentColor'}.merge(opts)
    opts[:class] = opts[:class].to_s.split unless opts[:class].is_a?(Array)
    opts[:class] += ['bi']
    tag.svg(opts) do
      tag.use('xlink:href': asset_pack_path('static/bootstrap-icons.svg') + '#' + name)
    end
  end
end
