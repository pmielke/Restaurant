#!/usr/bin/env ruby

require_relative "restaurant"

# set up the order

theorder = RequestList.new
theorder.settotalmeals(50)
theorder.addrestriction('vegetarian', 5)
theorder.addrestriction('gluten free',7)

puts "Team needs: #{theorder.to_pretty}"

# set up the list of restaurants

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
