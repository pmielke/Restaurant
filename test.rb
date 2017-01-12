#!/usr/bin/env ruby

require_relative "restaurant"
require "test/unit"

class TestRestaurant < Test::Unit::TestCase
  def create_request
    theorder = RequestList.new
    theorder.settotalmeals(50)
    theorder.addrestriction('vegetarian', 5)
    theorder.addrestriction('gluten free',7)
    theorder
  end

  def create_restarauntA
    tmp = Restaurant.new("A", 5)
    tmp.settotalmeals(40)
    tmp.addrestriction('vegetarian', 4)
    tmp
  end

  def create_restarauntB
    tmp = Restaurant.new('B', 3)
    tmp.settotalmeals(100)
    tmp.addrestriction('vegetarian',20)
    tmp.addrestriction('gluten free',20)

    tmp
  end

  def test_1_Initialization

    tmp = Meal.new('regular', 2)
    assert_equal("Meal(regular, 2)",
                 tmp.to_s)

    tmp = Restaurant.new("Fancy", 4)
    assert_equal("Restaurant( Fancy, MealList())",
                 tmp.to_s)

    theorder = create_request
    assert_equal("MealList(Meal(others, 38), Meal(vegetarian, 5), Meal(gluten free, 7))",
                 theorder.to_s)
    assert_equal(false,
                 theorder.complete )

    restA = create_restarauntA
    assert_equal("Restaurant( A, MealList(Meal(others, 36), Meal(vegetarian, 4)))",
                 restA.to_s)

    restB = create_restarauntB
    assert_equal("Restaurant( B, MealList(Meal(others, 60), Meal(vegetarian, 20), Meal(gluten free, 20)))",
                 restB.to_s)
  end

  def test_2_Composition
    theorder = RequestList.new
    theorder.settotalmeals(50)
    assert_equal("MealList(Meal(others, 50))",
                 theorder.to_s)

    theorder.addrestriction('vegetarian',20)
    assert_equal("MealList(Meal(others, 30), Meal(vegetarian, 20))",
                 theorder.to_s)

    # attempt to add more that the total set

    theorder = RequestList.new
    theorder.settotalmeals(10)
    assert_equal("MealList(Meal(others, 10))",
                 theorder.to_s)
    assert_equal(10,
                 theorder.howmany('others'))

    retval = theorder.addrestriction('vegetarian',20)
    assert_equal(0,
                 retval)
    assert_equal(0,
                 theorder.howmany('vegetarian'))

    assert_equal("MealList(Meal(others, 10))",
                 theorder.to_s)
  end

  def test_3_Sample
    therequest = create_request
    assert_equal("MealList(Meal(others, 38), Meal(vegetarian, 5), Meal(gluten free, 7))",
                 therequest.to_s)

    therestarauntlist = RestaurantList.new
    assert_equal("",
                 therestarauntlist.to_s)

    therestarauntlist.addRestaurant( create_restarauntA )
    assert_equal("  Restaurant( A, MealList(Meal(others, 36), Meal(vegetarian, 4)))\n",
                 therestarauntlist.to_s)

    therestarauntlist.addRestaurant( create_restarauntB )
    assert_equal("  Restaurant( A, MealList(Meal(others, 36), Meal(vegetarian, 4)))\n" +
                 "  Restaurant( B, MealList(Meal(others, 60), Meal(vegetarian, 20), Meal(gluten free, 20)))\n",
                 therestarauntlist.to_s)

    fulfillment = therestarauntlist.fulfill(therequest)
    assert_equal(true,
                therequest.complete)
    assert_equal("The order\n" +
                 "  Restaurant( A, MealList(Meal(others, 36), Meal(vegetarian, 4)))\n" +
                 "  Restaurant( B, MealList(Meal(others, 2), Meal(vegetarian, 1), Meal(gluten free, 7)))\n",
                 fulfillment.to_s)

    assert_equal("Expected meal orders: Restaurant A (4 vegetarian + 36 others), Restaurant B (7 gluten free + 1 vegetarian + 2 others)",
                 fulfillment.to_pretty)


    therequest = create_request
    assert_equal("MealList(Meal(others, 38), Meal(vegetarian, 5), Meal(gluten free, 7))",
                 therequest.to_s)

    therestarauntlist = RestaurantList.new
    assert_equal("",
                 therestarauntlist.to_s)

    therestarauntlist.addRestaurant( create_restarauntB )
    assert_equal("  Restaurant( B, MealList(Meal(others, 60), Meal(vegetarian, 20), Meal(gluten free, 20)))\n",
                 therestarauntlist.to_s)

    therestarauntlist.addRestaurant( create_restarauntA )
    assert_equal("  Restaurant( B, MealList(Meal(others, 60), Meal(vegetarian, 20), Meal(gluten free, 20)))\n" +
                 "  Restaurant( A, MealList(Meal(others, 36), Meal(vegetarian, 4)))\n",
                 therestarauntlist.to_s)

    fulfillment = therestarauntlist.fulfill(therequest)
    assert_equal(true,
                therequest.complete)
    assert_equal("The order\n" +
                 "  Restaurant( A, MealList(Meal(others, 36), Meal(vegetarian, 4)))\n" +
                 "  Restaurant( B, MealList(Meal(others, 2), Meal(vegetarian, 1), Meal(gluten free, 7)))\n",
                 fulfillment.to_s)
  end

  def test_4_Incomplete_Fulfillment
    therequest = RequestList.new
    therequest.settotalmeals(150)
    therequest.addrestriction('vegetarian', 10)
    therequest.addrestriction('gluten free',14)
    assert_equal("MealList(Meal(others, 126), Meal(vegetarian, 10), Meal(gluten free, 14))",
                therequest.to_s)

    therestarauntlist = RestaurantList.new
    therestarauntlist.addRestaurant( create_restarauntA )
    therestarauntlist.addRestaurant( create_restarauntB )

    fulfillment = therestarauntlist.fulfill(therequest)

    assert_equal(false,
                therequest.complete)
  end

  # test em
  def test_5_Empty_List
    therequest = RequestList.new
    assert_equal(true,
                 therequest.complete)

    therestarauntlist = RestaurantList.new

    fulfillment = therestarauntlist.fulfill(therequest)
    assert_equal("",
                 fulfillment.to_s)
  end

end
