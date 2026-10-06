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
end
