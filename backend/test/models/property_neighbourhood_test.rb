require "test_helper"

class PropertyNeighbourhoodTest < ActiveSupport::TestCase
  test "does not assign the same neighbourhood twice" do
    duplicate = PropertyNeighbourhood.new(
      property: properties(:one),
      neighbourhood: neighbourhoods(:hatchobori)
    )

    assert_not duplicate.valid?
  end
end
