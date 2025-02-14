module UIHelpers
  def click_and_expect(element, text, path)
    case element
    when :link
      click_link text
    when :button
      click_button text
    else
      raise ArgumentError, "Invalid element type #{element}."
    end

    expect(page).to have_current_path(path, wait: 10)
  end

  def expect_page_content(*arr)
    arr.each { |n| expect(page).to have_content(n) }
  end
end
