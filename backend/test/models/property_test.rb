require "test_helper"

class PropertyTest < ActiveSupport::TestCase
  test "requires a unique URL-safe slug" do
    Property.create!(
      name: "Section L Ginza", address: "1 Ginza", description: "In Ginza",
      city: "Tokyo", slug: "ginza"
    )

    duplicate = Property.new(
      name: "Another Ginza", address: "2 Ginza", description: "Also Ginza",
      city: "Tokyo", slug: "ginza"
    )
    unsafe = Property.new(
      name: "Unsafe", address: "3 Ginza", description: "Unsafe slug",
      city: "Tokyo", slug: "Ginza East"
    )

    assert_not duplicate.valid?
    assert_not unsafe.valid?
  end


  test "can belong to multiple neighbourhoods" do
    property = properties(:one)

    property.neighbourhoods << neighbourhoods(:ginza)

    assert_equal [ "Ginza", "Hatchobori" ], property.neighbourhoods.order(:name).pluck(:name)
  end

  test "finds distinct city gems through its neighbourhoods" do
    property = Property.create!(
      name: "Section L Distinct", address: "1 Test Street",
      description: "A test property", city: "Tokyo", slug: "distinct-test"
    )
    first_neighbourhood = Neighbourhood.create!(name: "Distinct One", city: "Tokyo")
    second_neighbourhood = Neighbourhood.create!(name: "Distinct Two", city: "Tokyo")
    property.neighbourhoods = [ first_neighbourhood, second_neighbourhood ]

    city_gem = city_gems(:one)
    city_gem.neighbourhoods = [ first_neighbourhood, second_neighbourhood ]

    assert_equal [ city_gem.id ], property.city_gems.pluck(:id)
  end
end
