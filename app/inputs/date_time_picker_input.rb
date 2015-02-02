class DateTimePickerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    template.content_tag(:div, class: 'form-group date time form_datetime') do
      template.concat @builder.text_field(attribute_name, date_input_html_options)
      template.concat @builder.text_field(attribute_name, time_input_html_options)
    end
  end

  def date_input_html_options
    options = {
      id: "#{attribute_name}_date",
      class: 'form-control datepicker',
      name: "#{object_name}[#{attribute_name}_date]",
      readonly: true,
      style: 'margin-right: 10px; width: auto; display: inline-block;'
    }

    options[:value] = @builder.object[attribute_name].strftime("%B %e, %Y") unless @builder.object[attribute_name].nil?
    options
  end

  def time_input_html_options
    options = {
      id: "#{attribute_name}_time",
      class: 'form-control timepicker',
      name: "#{object_name}[#{attribute_name}_time]",
      readonly: true,
      style: 'width: auto; display: inline-block;'
    }

    if @builder.object[attribute_name].nil?
      options[:value] = "12:00 AM"
    else
      options[:value] = @builder.object[attribute_name].strftime("%I:%M %p")
    end

    options
  end
end