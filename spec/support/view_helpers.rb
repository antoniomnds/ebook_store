module ViewSpecHelpers
  # Stub's the <tt>partial_path</tt> template and asserts that the <tt>stub_output</tt>
  # replacing the partial is in the rendered content.
  #
  # An alternative approach would be to create a spy on <tt>render</tt> and assert
  # that the method was called with the partial path:
  #   allow(view).to receive(:render).and_call_original
  #   render
  #   expect(view).to have_received(:render).with("path/to/partial").once
  # However, this way the partial is actually rendered, thus we're not isolating the test
  # or testing only the system under test (the main template).
  def expect_partial_to_be_rendered(partial_path, stub_output = "rendered stub")
    stub_template partial_path => stub_output

    render

    expect(rendered).to include(stub_output)
  end
end
