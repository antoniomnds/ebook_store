module RedirectWithFlashMatcher
  extend RSpec::Matchers::DSL

  matcher :redirect_with_flash_to do |expected_url, flash_type|
    match do |response|
      response.redirect? &&
        response.redirect_url == expected_url &&
        flash[flash_type].present?
    end

    failure_message do |response|
      messages = []
      messages << "expected response to be a redirect but was #{response.status}" unless response.redirect?
      messages << "expected redirect to #{expected_url} but was #{response.redirect_url}" if response.redirect_url != expected_url
      messages << "expected flash[:#{flash_type}] to be present" unless flash[flash_type].present?
      messages.join(", and ")
    end

    description do
      "redirect with #{flash_type} flash to #{expected_url}"
    end
  end
end
