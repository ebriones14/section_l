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
    market = Neighbourhood.create!(name: "Tsukiji Market", city: "Tokyo")
    waterfront = Neighbourhood.create!(name: "Tsukiji Waterfront", city: "Tokyo")
    elsewhere = Neighbourhood.create!(name: "Shinjuku", city: "Tokyo")
    @property.neighbourhoods = [ market, waterfront ]

    @coffee = CityGem.create!(
      name: "Turret Coffee", category: "Coffee",
      short: "A tiny espresso bar.", long: "A tiny espresso bar near the market.",
      maps: "https://maps.example.com/turret"
    )
    @coffee.neighbourhoods = [ market, waterfront ]
    @garden = CityGem.create!(
      name: "Hamarikyu Gardens", category: "Explore",
      short: "A peaceful garden.", long: "A peaceful garden near the property.",
      maps: "https://maps.example.com/garden"
    )
    @garden.neighbourhoods = [ waterfront ]
    @distant_gem = CityGem.create!(
      name: "Distant Cafe", category: "Coffee",
      short: "Too far away.", long: "A valid gem outside the property's neighbourhoods.",
      maps: "https://maps.example.com/distant"
    )
    @distant_gem.neighbourhoods = [ elsewhere ]
  end

  test "lists properties" do
    get "/api/v1/properties"

    assert_response :success
    payload = response.parsed_body
    assert_equal "tsukiji", payload.dig("properties", 0, "slug")
  end

  test "shows distinct city gems matching the property's neighbourhoods" do
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
