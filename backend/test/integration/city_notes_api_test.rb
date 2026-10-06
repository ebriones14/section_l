require "test_helper"

class CityNotesApiTest < ActionDispatch::IntegrationTest
  setup do
    CityGemNeighbourhood.delete_all
    PropertyNeighbourhood.delete_all
    CityGem.delete_all
    Property.delete_all

    @property = Property.create!(
      name: "Section L Tsukiji", city: "Tokyo", slug: "tsukiji",
      address: "4 Chome Tsukiji, Chuo City, Tokyo", description: "Near the market"
    )
    @coffee = CityGem.create!(
      property: @property, name: "Turret Coffee", category: "Coffee",
      short: "A tiny espresso bar.", long: "A tiny espresso bar near the market.",
      maps: "https://maps.example.com/turret"
    )
    @garden = CityGem.create!(
      property: @property, name: "Hamarikyu Gardens", category: "Explore",
      short: "A peaceful garden.", long: "A peaceful garden near the property.",
      maps: "https://maps.example.com/garden"
    )
  end

  test "lists properties" do
    get "/api/v1/properties"

    assert_response :success
    payload = response.parsed_body
    assert_equal "tsukiji", payload.dig("properties", 0, "slug")
  end

  test "shows the city gems that belong to a property" do
    get "/api/v1/properties/tsukiji"

    assert_response :success
    assert_equal [ "Hamarikyu Gardens", "Turret Coffee" ],
      response.parsed_body.dig("property", "city_gems").pluck("name")
  end

  test "returns a JSON 404 for an unknown property" do
    get "/api/v1/properties/missing"

    assert_response :not_found
    assert_equal "Resource not found", response.parsed_body["error"]
  end
end
