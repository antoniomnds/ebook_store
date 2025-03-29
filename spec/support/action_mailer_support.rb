module ActionMailerSupport
  # taken from https://stackoverflow.com/questions/72665071/how-to-best-use-rspec-mocks-when-using-rails-mailer-parameterization
  def expect_mailer_call(mailer, action, params, delivery_method = :deliver_later)
    mailer_double = instance_double(mailer)
    message_delivery_double = instance_double(ActionMailer::MessageDelivery)

    expect(mailer).to receive(:with).with(params).and_return(mailer_double)
    expect(mailer_double).to receive(action).with(no_args).and_return(message_delivery_double)
    expect(message_delivery_double).to receive(delivery_method).once
  end
end

RSpec.configure do |config|
  config.include ActionMailerSupport
end
