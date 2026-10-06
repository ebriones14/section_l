require "test_helper"

class CityGemTest < ActiveSupport::TestCase
  test "belongs to a property and requires guest-facing content" do
    city_gem = CityGem.new(name: "Coffee Stand", category: "Coffee")

    assert_not city_gem.valid?
    assert_includes city_gem.errors[:property], "must exist"
    assert_includes city_gem.errors[:short], "can't be blank"
    assert_includes city_gem.errors[:long], "can't be blank"
    assert_includes city_gem.errors[:maps], "can't be blank"
  end

  test "can belong to multiple neighbourhoods" do
    city_gem = city_gems(:one)

    city_gem.neighbourhoods << neighbourhoods(:ginza)

    assert_equal [ "Ginza", "Hatchobori" ], city_gem.neighbourhoods.order(:name).pluck(:name)
  end
end
