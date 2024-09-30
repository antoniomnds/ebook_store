RSpec.shared_context 'logging' do
  before(:context) do
    puts("Initializing #{described_class} test suite")
  end

  after(:context) do
    puts("Finalized #{described_class} test suite")
  end
end
