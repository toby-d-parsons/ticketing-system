module UIHelpers
  def click_and_expect(element, text, path)
    case element
    when :link
      # Capybara requires link text to be a String or Symbol.
      click_link text.to_s
    when :button
      click_button text
    when :testid
      find("[data-testid=#{text}]").click
    else
      raise ArgumentError, "Invalid element type #{element}."
    end

    expect(page).to have_current_path(path, wait: 10)
  end

  def expect_page_content(*arr)
    arr.each { |n| expect(page).to have_content(n) }
  end
end
