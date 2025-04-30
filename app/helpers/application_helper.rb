module ApplicationHelper
  # Returns label text with an asterisk if the field is required.
  # To be used inside form.label blocks; does not generate the <label> tag itself.
  def label_text_with_required(form, field)
    text = form.object.class.human_attribute_name(field)

    if form.object.class.validators_on(field).any? { |v| v.kind == :presence }
      text += content_tag(:span, "*", class: "font-bold text-red-500 ml-1")
    end

    text.html_safe
  end
end
