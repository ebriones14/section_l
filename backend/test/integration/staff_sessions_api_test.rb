require "test_helper"

class StaffSessionsApiTest < ActionDispatch::IntegrationTest
  setup do
    @original_staff_pin = ENV["STAFF_CONFIG_PIN"]
    ENV["STAFF_CONFIG_PIN"] = "test-pin"
  end

  teardown do
    ENV["STAFF_CONFIG_PIN"] = @original_staff_pin
  end

  test "creates a short-lived session for the correct PIN" do
    post "/api/v1/staff/session", params: { pin: "test-pin" }, as: :json

    assert_response :success
    assert response.parsed_body["token"].present?
    assert_equal 15.minutes.to_i, response.parsed_body["expires_in"]
  end

  test "rejects an incorrect PIN" do
    post "/api/v1/staff/session", params: { pin: "wrong" }, as: :json

    assert_response :unauthorized
    assert_equal "Incorrect staff PIN", response.parsed_body["error"]
  end

  test "validates a signed staff session" do
    post "/api/v1/staff/session", params: { pin: "test-pin" }, as: :json
    token = response.parsed_body.fetch("token")

    get "/api/v1/staff/session", headers: { "Authorization" => "Bearer #{token}" }

    assert_response :success
    assert_equal true, response.parsed_body["authenticated"]
  end

  test "rejects an invalid staff session" do
    get "/api/v1/staff/session", headers: { "Authorization" => "Bearer invalid" }

    assert_response :unauthorized
  end

  test "allows the frontend to submit the staff PIN across origins" do
    options "/api/v1/staff/session", headers: {
      "Origin" => "http://localhost:5173",
      "Access-Control-Request-Method" => "POST"
    }

    assert_response :success
    assert_includes response.headers["Access-Control-Allow-Methods"], "POST"
  end
end
