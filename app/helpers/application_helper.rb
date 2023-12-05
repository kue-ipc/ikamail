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
        label: t("menu.paths.admin_root"),
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
      path: mail_templates_path,
      label: t_menu_action(:index, model: :mail_template, count: 2),
    }
    list << {
      path: recipient_lists_path,
      label: t_menu_action(:index, model: :recipient_list, count: 2),
    }
    list << {
      path: new_search_path,
      label: t_menu_action(:search, model: :mail_user, count: 1),
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
    content_tag("div", class: "row border-bottom mb-2 pb-2") do
      content_tag("dt", term, class: "col-md-4 col-lg-3 col-xxl-2") +
        content_tag("dd", class: "col-md-8 col-lg-9 col-xxl-10 mb-0", &block)
    end
  end

  def dt_dd_for(recored, attr, **opts)
    if block_given?
      dt_dd_tag recored.class.human_attribute_name(attr) do
        yield recored.__send__(attr)
      end
    else
      dt_dd_for(recored, attr, **opts) do |value|
        span_value_for(value, **opts)
      end
    end
  end

  def span_value_for(value, **opts)
    case value
    when nil
      content_tag("span", opts[:blank_alt] || t("values.none"), class: "font-italic text-muted")
    when "", [], {}
      content_tag("span", opts[:blank_alt] || t("values.empty"), class: "font-italic text-muted")
    when String
      span_string_for(value, **opts)
    when Time, Date, DateTime, ActiveSupport::TimeWithZone
      content_tag("span", l(value, format: opts[:format]))
    when true, false
      span_bool_for(value, **opts)
    when Enumerable
      span_enum_for(value, **opts)
    when BulkMail, MailGroup, MailUser, RecipientList, MailTemplate
      span_model_for(value, **opts)
    else
      content_tag("span", value.to_s, class: "")
    end
  end

  def span_model_for(value, **opts)
    if policy(value).show?
      link_to(value.to_s, value, **opts)
    else
      content_tag("span", value.to_s, **opts)
    end
  end

  def span_string_for(value, **opts)
    case opts[:format]
    when :mail_body
      mail_body_tag(value, **opts)
    when :translate
      span_text_tag(t(value, scope: opts[:scope]), **opts)
    else
      span_text_tag(value, **opts)
    end
  end

  def span_bool_for(value, **opts)
    if value
      octicon("check-circle-fill", class: "text-success", **opts)
    else
      octicon("x-circle-fill", class: "text-danger", **opts)
    end
  end

  def span_enum_for(value, limits: nil, **opts)
    content_tag("ul", class: "list-inline mb-0") do
      list_html = sanitize("")
      value.each do |v|
        next if limits&.exclude?(v)

        list_html += content_tag("li", class: "list-inline-item border border-primary rounded px-1 mb-1") do
          span_value_for(v, **opts)
        end
      end
      list_html
    end
  end

  def mail_body_tag(value, **opts)
    content_tag("pre", value, class: "border rounded mb-0 mail-body line-76-80") do
      span_text_tag(value, **opts)
    end
  end

  def span_text_tag(value, around: nil, pre: false, **_)
    if around.present?
      content_tag("span", around[0], class: "text-muted") +
        span_text_tag(value, around: nil, pre: pre) +
        content_tag("span", around[1], class: "text-muted")
    elsif pre
      # rubocop: disable Rails/OutputSafety
      content_tag("span", value.split(/\R/).map { |s| h(s) }.join(tag.br).html_safe)
      # rubocop: enable Rails/OutputSafety
    else
      content_tag("span", value)
    end
  end

  def html_month(time)
    time.strftime("%Y-%m")
  end

  def html_date(time)
    time.strftime("%Y-%m-%d")
  end

  def html_time(time, second: true)
    if second
      time.strftime("%H:%M:%S")
    else
      time.strftime("%H:%M")
    end
  end

  def html_datetime_local(time, second: true)
    if second
      time.strftime("%Y-%m-%dT%H:%M:%S")
    else
      time.strftime("%Y-%m-%dT%H:%M")
    end
  end

  def html_datetime_zone(time)
    time.xmlschema
  end

  def file_name(obj, attr: nil, format: "txt")
    model = obj.class.model_name.i18n_key
    str = "#{t_model(model)}[#{obj.name}]"
    str += t_attr(attr, model: model) if attr
    str += ".#{format}"
    str
  end
end
