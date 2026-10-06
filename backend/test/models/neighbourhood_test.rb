require "test_helper"

class NeighbourhoodTest < ActiveSupport::TestCase
  test "requires a unique name" do
    duplicate = Neighbourhood.new(name: neighbourhoods(:ginza).name)

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end
end
