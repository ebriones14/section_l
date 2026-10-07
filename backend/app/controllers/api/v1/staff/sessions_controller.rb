require "digest"

module Api
  module V1
    module Staff
      class SessionsController < BaseController
        SESSION_DURATION = 15.minutes

        rate_limit to: 5, within: 1.minute, only: :create, with: -> {
          render json: { error: "Too many attempts. Try again in a minute." }, status: :too_many_requests
        }

        def create
          return configuration_unavailable unless configured_pin?
          return invalid_pin unless valid_pin?

          render json: {
            token: verifier.generate("staff", expires_in: SESSION_DURATION, purpose: :staff_configuration),
            expires_in: SESSION_DURATION.to_i
          }
        end

        def show
          if valid_token?
            render json: { authenticated: true }
          else
            render json: { error: "Staff session is invalid or has expired" }, status: :unauthorized
          end
        end

        private

        def configured_pin
          ENV["STAFF_CONFIG_PIN"].to_s
        end

        def configured_pin?
          configured_pin.present?
        end

        def valid_pin?
          ActiveSupport::SecurityUtils.secure_compare(
            Digest::SHA256.hexdigest(params[:pin].to_s),
            Digest::SHA256.hexdigest(configured_pin)
          )
        end

        def valid_token?
          scheme, token = request.authorization.to_s.split(" ", 2)
          return false unless scheme == "Bearer" && token.present?

          verifier.verified(token, purpose: :staff_configuration) == "staff"
        end

        def verifier
          Rails.application.message_verifier("staff_configuration")
        end

        def invalid_pin
          render json: { error: "Incorrect staff PIN" }, status: :unauthorized
        end

        def configuration_unavailable
          render json: { error: "Staff configuration is not available" }, status: :service_unavailable
        end
      end
    end
  end
end
