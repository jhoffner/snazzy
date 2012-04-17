class ActionView::Helpers::FormBuilder

  def input_error_class_name(sym, errorClass="error", cleanClass="")
    has_error?(sym) ? errorClass : cleanClass
  end

  #
  # Wraps content within a control-group div along with a label and a controls div.
  # The block is added within the controls div. error messaging is handled automatically
  #
  def control_group(field_name, options={}, &block)

    group_options = {
        options: options[:group_options],
        id: options[:group_id]
    }

    add_class_name(group_options, 'control-group')
    add_class_name(group_options, input_error_class_name(field_name))

    @template.content_tag :div, group_options do
      group_html = label field_name, options[:label_text], class: 'control-label'
      group_html += controls_container(field_name, &block)
    end
  end

  def controls_container(field_name, &block)
    @template.content_tag :div, class: 'controls' do
      html = @template.capture &block

      html += field_errors(field_name) if has_error? field_name
      html
    end
  end

  def field_errors(field_name)
    @template.content_tag :div, class: 'alert alert-error field-error' do
      alert_html = @template.content_tag :ul do
        ul_html = ''
        @object.errors[field_name].each do |error|
          ul_html += @template.content_tag :li, error.humanize, class: nil
        end
        @template.raw ul_html
      end
    end
  end

  def submit_btn(text)
    submit text, class:'btn btn-primary'
  end

  private

  def has_error?(sym)
    @object.errors.include? sym
  end

  def add_class_name(hash, adding, name = :class)
    if (hash[name].blank?)
      hash[name] = adding
    elsif !adding.blank?
      hash[name] += ' ' + adding
    end
  end
end