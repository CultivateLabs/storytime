inputs = %w[
  CollectionSelectInput
  DateTimeInput
  FileInput
  GroupedCollectionSelectInput
  NumericInput
  PasswordInput
  RangeInput
  StringInput
  TextInput
]

inputs.each do |input_type|
  "SimpleForm::Inputs::#{input_type}".constantize.class_eval do
    alias_method :__input_html_classes, :input_html_classes
    define_method(:input_html_classes) do
      __input_html_classes.push('form-control')
    end
  end
end
 
# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.boolean_style = :nested
  
  config.button_class = 'btn btn-default'
 
  config.wrappers :bootstrap3, tag: 'div', class: 'form-group', error_class: 'has-error',
      defaults: { input_html: { class: 'default_class' } } do |b|
    
    b.use :html5
    b.use :min_max
    b.use :maxlength
    b.use :placeholder
    
    b.optional :pattern
    b.optional :readonly
    
    b.use :label_input
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    b.use :error, wrap_with: { tag: 'span', class: 'help-block has-error' }
  end
 
  config.wrappers :prepend, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'controls' do |input|
      input.wrapper tag: 'div', class: 'input-group' do |prepend|
    prepend.use :label , class: 'input-group-addon' ###Please note setting class here fro the label does not currently work (let me know if you know a workaround as this is the final hurdle)
        prepend.use :input
      end
      input.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      input.use :error, wrap_with: { tag: 'span', class: 'help-block has-error' }
    end
  end
 
  config.wrappers :append, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'controls' do |input|
      input.wrapper tag: 'div', class: 'input-group' do |prepend|
        prepend.use :input
    prepend.use :label , class: 'input-group-addon' ###Please note setting class here fro the label does not currently work (let me know if you know a workaround as this is the final hurdle)
      end
      input.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      input.use :error, wrap_with: { tag: 'span', class: 'help-block has-error' }
    end
  end
 
  config.wrappers :checkbox, tag: :div, class: "checkbox", error_class: "has-error" do |b|
 
    # Form extensions
    b.use :html5
 
    # Form components
    b.wrapper tag: :label do |ba|
      ba.use :input
      ba.use :label_text
    end
 
    b.use :hint,  wrap_with: { tag: :p, class: "help-block" }
    b.use :error, wrap_with: { tag: :span, class: "help-block text-danger" }
  end
 
  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://getbootstrap.com/)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :bootstrap3
end