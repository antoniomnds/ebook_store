# frozen_string_literal: true

module Api
  class ApiService < ApplicationService
    NUM_RETRIES = 3

    def make_request(uri, method, fail_message, headers = {}, body = {})
      req = create_request(uri, method, headers, body)
      retries = 0

      begin
        response = Net::HTTP.start(uri.hostname, use_ssl: true) do |http|
          http.request(req)
        end

        if response.is_a?(Net::HTTPSuccess)
          data = JSON.parse(response.body)
          yield(data) if block_given?
        else
          log_response(fail_message, response)
          nil
        end
      rescue Net::OpenTimeout
        Rails.logger.error { "ERROR: Failed to open connection with the API. Retrying #{retries}" }
        retries += 1
        sleep(1)
        retry if retries < NUM_RETRIES
      end
    end

    def create_request(uri, method, headers, payload)
      headers.merge!(
        {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
      )
      request =
        case method
        when :get
          Net::HTTP::Get.new(uri, headers)
        when :post
          Net::HTTP::Post.new(uri, headers)
        else
          raise NotImplementedError
        end
      request.body = payload.to_json
      request
    end

    def log_response(message, response, type = :info)
      return unless response.is_a? Net::HTTPResponse

      log_message = %Q(
        Error: #{ message }
        HTTP code: #{ response.status }
        HTTP response message: #{ response.message }
        HTTP response body: #{ response.body }
      )
      Rails.logger.send(type) { log_message }
    end
  end
end