# Problem statement

We're ordering meals for a team lunch. Every member in the team needs
one meal, some have dietary restrictions such as vegetarian, gluten
free, nut free, and fish free. We have a list of restaurants which
serve meals that satisfy some of these restrictions. Each restaurant
has a rating, and a limited amount of meals in stock that they can
make today. Implement an object oriented system with automated tests
that can automatically produce the best possible meal orders with
reasonable assumptions.

## Example:

Team needs: total 50 meals including 5 vegetarians and 7 gluten free.

Restaurants:
* Restaurant A has a rating of 5/5 and can serve 40 meals including 4 vegetarians
* Restaurant B has a rating of 3/5 and can serve 100 meals including 20 vegetarians, and 20 gluten free

Expected meal orders: Restaurant A (4 vegetarian + 36 others), Restaurant B (1 vegetarian + 7 gluten free + 2 others)

# OO Design

![alt text](https://github.com/pmielke/Restaurant/raw/master/classdiagram.png "Overview Diagram")

## Class descriptions

### Meal

Container class for a meal type

### MealList

Container class for a list of meals.

### RequestList

Container class for list of meals that are to be ordered

### Restaurant

Container class for group of meals that can be made by a restaurant.

### RestaurantList

Container class for a group of restaurants

# Implementation

The problem is implemented in Ruby (see `restaurants.rb`). Test cases are in `test.rb`.

## Sample


```ruby
#!/usr/bin/env ruby

require_relative "restaurant"

# initialize the order

theorder = RequestList.new
theorder.settotalmeals(50)
theorder.addrestriction('vegetarian', 5)
theorder.addrestriction('gluten free',7)

puts "Team needs: #{theorder.to_pretty}"

# initialize the list of restaurants

restA = Restaurant.new("A", 5)
restA.settotalmeals(40)
restA.addrestriction('vegetarian', 4)

restB = Restaurant.new('B', 3)
restB.settotalmeals(100)
restB.addrestriction('vegetarian',20)
restB.addrestriction('gluten free',20)

therestarauntlist = RestaurantList.new

therestarauntlist.addRestaurant( restA )
therestarauntlist.addRestaurant( restB )

# determine the order fulfillment

fulfillment = therestarauntlist.fulfill(theorder)

puts

puts fulfillment.to_pretty

```