class RadioLabelInput < SimpleForm::Inputs::CollectionRadioButtonsInput
  def input
    label_method, value_method = detect_collection_methods
    iopts = { 
      :collection_wrapper_tag => 'div',
      :collection_wrapper_class => 'grouped inline fields skill-level'
     }
    return @builder.send(
      "collection_radio_buttons",
      attribute_name,
      collection,
      value_method,
      label_method,
      iopts,
      input_html_options,
      &collection_block_for_nested_boolean_style
    )
  end

  protected

  def build_nested_boolean_style_item_tag(collection_builder)
    tag = String.new
    tag << '<span class="ui radio checkbox">'.html_safe
    tag << collection_builder.radio_button + collection_builder.label
    tag << '</span>'.html_safe
    return tag.html_safe
  end
end
