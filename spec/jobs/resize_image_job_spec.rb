require 'rails_helper'

RSpec.describe ResizeImageJob, type: :job do
  let(:user) { build_stubbed(:user) }
  let(:image_size) { [ 250, 250 ] }
  let(:args) { [ user.class.name, user.id, :avatar, *image_size ] }

  it "matches with enqueued job" do
    expect { ResizeImageJob.perform_later(*args) }.to have_enqueued_job.with(*args)
  end

  context "when the attachment is not attached" do
    it "will not resize the attachment" do
      allow(User).to receive(:find).with(user.id).and_return(user)
      avatar_mock = double(:avatar, attached?: false) # "unverified" double since the variant method is only available through delegation at runtime
      allow(avatar_mock).to receive(:variant)
      allow(user).to receive(:avatar).and_return(avatar_mock)

      described_class.perform_now(*args)

      expect(avatar_mock).not_to have_received(:variant)
    end
  end

  context "when the attachment is attached" do
    it "will resize the attachment" do
      allow(User).to receive(:find).with(user.id).and_return(user)
      avatar_mock = double(:avatar, attached?: true)
      variant_mock = double(:variant)
      allow(variant_mock).to receive(:processed).and_return(variant_mock) # processed returns the variant after it's been processed
      allow(avatar_mock).to receive(:variant).and_return(variant_mock)  # stub variant method since it's only available through delegation at runtime
      allow(user).to receive(:avatar).and_return(avatar_mock)

      described_class.perform_now(*args)

      expect(avatar_mock).to have_received(:variant).with(hash_including(:resize_to_limit))
      expect(variant_mock).to have_received(:processed).with(no_args)
    end
  end
end
