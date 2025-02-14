module ResponseMatchers
  def expect_response_content(*arr)
    arr.each { |n| expect(response.body).to include(n.to_s) }
  end
end
