RSpec.shared_examples 'model' do
  context "with valid attributes" do
    it { is_expected.to be_valid }
  end

  it "is persisted to the database" do
    expect { subject.save }.to change { described_class.count }.by(1)
  end
end
