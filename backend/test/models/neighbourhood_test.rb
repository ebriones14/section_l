require "test_helper"

class NeighbourhoodTest < ActiveSupport::TestCase
  test "requires a unique name" do
    duplicate = Neighbourhood.new(name: neighbourhoods(:ginza).name, city: "Tokyo")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end

  test "allows the same name in another city" do
    neighbourhood = Neighbourhood.new(name: neighbourhoods(:ginza).name, city: "Osaka")

    assert neighbourhood.valid?
  end
end
