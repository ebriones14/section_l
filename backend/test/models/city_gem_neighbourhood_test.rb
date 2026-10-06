require "test_helper"

class CityGemNeighbourhoodTest < ActiveSupport::TestCase
  test "does not assign the same neighbourhood twice" do
    duplicate = CityGemNeighbourhood.new(
      city_gem: city_gems(:one),
      neighbourhood: neighbourhoods(:hatchobori)
    )

    assert_not duplicate.valid?
  end
end
