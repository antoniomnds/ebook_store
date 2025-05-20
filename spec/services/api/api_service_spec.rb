require 'rails_helper'

RSpec.describe ::Api::ApiService do
  describe "#make_request" do
    context "when a connection is made" do
      context "when the request is successful" do
        it "yields control to the block given" do
          service = described_class.new
          uri = URI("https://example.com")
          method = :get
          fail_message = "API request failed"
          success_message = "API request was successful"
          request_double = instance_double(Net::HTTP::Get)
          response_double = instance_double(Net::HTTPResponse, body: success_message, is_a?: true)
          allow(service).to receive(:create_request).with(uri, method, {}, {}).and_return(request_double)
          allow(Net::HTTP).to receive(:start).with(uri.hostname, use_ssl: true).and_return(response_double)
          allow(JSON).to receive(:parse).with(success_message).and_return(success_message)

          expect { |block| service.make_request(uri, method, fail_message, &block) }.to yield_with_args(success_message)
        end
      end

      context "when the request is not successful" do
        it "logs the response" do
          service = described_class.new
          uri = URI("https://example.com")
          method = :get
          fail_message = "API request failed"
          request_double = instance_double(Net::HTTP::Get)
          response_double = instance_double(Net::HTTPResponse, body: "request was successful", is_a?: false)
          allow(service).to receive(:create_request).with(uri, method, {}, {}).and_return(request_double)
          allow(Net::HTTP).to receive(:start).with(uri.hostname, use_ssl: true).and_return(response_double)
          allow(service).to receive(:log_response)

          service.make_request(uri, method, fail_message)

          # the log_response behaviour is tested in another test
          expect(service).to have_received(:log_response).with(fail_message, response_double)
        end
      end
    end

    context "when no connection is established" do
      # raise Net::OpenTimeout to simulate connection failure
      it "retries the request" do
        retries = 5
        stub_const("#{described_class}::NUM_RETRIES", retries)
        service = described_class.new
        uri = URI("https://example.com")
        method = :get
        fail_message = "API request failed"

        allow(service).to receive(:create_request).with(uri, method, {}, {}).and_return(instance_double(Net::HTTP::Get))
        allow(Net::HTTP).to receive(:start).with(uri.hostname, use_ssl: true).and_raise(Net::OpenTimeout)
        allow(service).to receive(:sleep) # stub out sleep to speed up tests

        service.make_request(uri, method, fail_message)

        expect(Net::HTTP).to have_received(:start).exactly(retries).times
      end

      it "logs an error message" do
        retries = 5
        stub_const("#{described_class}::NUM_RETRIES", retries)

        service = described_class.new
        uri = URI("https://example.com")
        method = :get
        fail_message = "API request failed"

        allow(service).to receive(:create_request).with(uri, method, {}, {}).and_return(instance_double(Net::HTTP::Get))
        allow(Net::HTTP).to receive(:start).with(uri.hostname, use_ssl: true).and_raise(Net::OpenTimeout)
        allow(service).to receive(:sleep) # stub out sleep to speed up tests
        allow(Rails.logger).to receive(:error)

        service.make_request(uri, method, fail_message)

        expect(Rails.logger).to have_received(:error).exactly(retries).times
      end
    end
  end

  describe "#create_request" do
    it "includes accept and content type headers in the request" do
      uri = URI("https://example.com")

      result = described_class.new.create_request(uri, :get, {}, {})

      aggregate_failures do
        expect(result.to_hash).to include("accept" => [ "application/json" ])
        expect(result.to_hash).to include("content-type" => [ "application/json" ])
      end
    end

    it "sets the given payload as the request body" do
      uri = URI("https://example.com")
      payload = "some content"

      result = described_class.new.create_request(uri, :get, {}, payload)

      expect(result.body).to eq(payload.to_json)
    end

    context "when method is :get" do
      it "creates a get request" do
        uri = URI("https://example.com")
        method = :get

        result = described_class.new.create_request(uri, method, {}, {})

        expect(result).to be_a(Net::HTTP::Get)
      end
    end

    context "when method is :post" do
      it "creates a post request" do
        uri = URI("https://example.com")
        method = :post

        result = described_class.new.create_request(uri, method, {}, {})

        expect(result).to be_a(Net::HTTP::Post)
      end
    end

    context "when method is unknown" do
      it "creates a post request" do
        uri = URI("https://example.com")
        method = nil

        expect do
          described_class.new.create_request(uri, method, {}, {})
        end.to raise_error(NotImplementedError)
      end
    end
  end

  describe "#log_response" do
    context "when the response is not a Net::HTTPResponse" do
      it "returns nil" do
        message = "an error occurred"
        response = nil

        expect(described_class.new.log_response(message, response)).to be_nil
      end
    end

    context "when type has an unexpected value" do
      it "returns nil" do
        message = "an error occurred"
        response_double = instance_double(
          Net::HTTPBadRequest,
          "Bad Request",
          code: 400,
          body: message,
          is_a?: true
        )
        message_type = :random

        result = described_class.new.log_response(message, response_double, message_type)

        expect(result).to be_nil
      end
    end

    context "when type is error" do
      it "logs to the error logger" do
        message = "an error occurred"
        response_double = instance_double(
          Net::HTTPBadRequest,
          code: 400,
          message: "Bad Request",
          body: "some payload",
          is_a?: true
        )
        allow(Rails.logger).to receive(:error)

        described_class.new.log_response(message, response_double, :error)

        expect(Rails.logger).to have_received(:error).once
      end
    end

    context "when type is warn" do
      it "logs to the warning logger" do
        message = "an error occurred"
        response_double = instance_double(
          Net::HTTPBadRequest,
          code: 400,
          message: "Bad Request",
          body: "some payload",
          is_a?: true
        )
        allow(Rails.logger).to receive(:warn)

        described_class.new.log_response(message, response_double, :warn)

        expect(Rails.logger).to have_received(:warn).once
      end
    end

    it "logs to the info logger by default" do
      message = "an error occurred"
      response_double = instance_double(
        Net::HTTPBadRequest,
        code: 400,
        message: "Bad Request",
        body: "some payload",
        is_a?: true
      )
      allow(Rails.logger).to receive(:info)

      described_class.new.log_response(message, response_double)

      expect(Rails.logger).to have_received(:info).once
    end
  end
end
