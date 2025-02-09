module FormHelpers
  def fill_in_ticket_form_from_support_page(title:, description:)
    fill_in "Title", with: title
    fill_in "Description", with: description
  end
end
