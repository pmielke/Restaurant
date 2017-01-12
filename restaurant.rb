# A simple container for Meal type and quantity itemsDocument the responsibility of the class
#
class Meal
  # ==== Attributes
  #
  # * +type+ - The type of meal
  # * +quantity+ - The amount of meals
  #
  attr_accessor 'type', 'quantity'

  def initialize(type, quantity)
    @type = type
    @quantity = quantity
  end

  def to_s
    "#{self.class.name}(#{@type}, #{@quantity})"
  end

  def to_pretty
    "#{@quantity} #{@type}"
  end
end

# Container class of Meals

class MealList

  # name for the default meal type

  DEFAULT_MEAL = 'others'

  def initialize
    @meals = []
  end

  # Set the total default meals in this list. This will clear any
  # meals previously set.

  def settotalmeals(totalmeals)
    @meals = []
    self.addmeal(Meal.new(MealList::DEFAULT_MEAL,totalmeals))
  end

  # Set QUANTITY of meal TYPE to this list. This will decrease the
  # total amount previously set for the default meal. The number of
  # meals added is returned, 0 if the restriction could not be added.

  def addrestriction(type, quantity)
    if self.decrease(MealList::DEFAULT_MEAL, quantity)
      if not self.increase(type, quantity)
        self.addmeal(Meal.new(type, quantity))
      end
    else
      return 0
    end
    return quantity
  end

  # Add a meal to the list

  def addmeal(meal)
    @meals.push(meal)
  end

  # Return the number of meals of requested TYPE.

  def howmany(type)
    @meals.each do |meal|
      if meal.type == type
        return meal.quantity
      end
    end
    return 0
  end

  # Decrease the amount of meals of requested TYPE by QUANTITY. return true if
  # operation was successful.

  def decrease(type, quantity)
    @meals.each do |meal|
      if meal.type == type
        if meal.quantity >= quantity
          meal.quantity -= quantity
          return true
        end
      end
    end
    return false
  end

  # Increase the amount of meals of requested TYPE by QUANTITY.  Return true if
  # operation was successful. No new types of meals are added.

  def increase(type, quantity)
    @meals.each do |meal|
      if meal.type == type
        meal.quantity += quantity
        return true
      end
    end
    return false
  end

  def to_s
    'MealList(' + @meals.join( ', ' ) + ')'
  end

  # a pretty output of the list

  def to_pretty
    # sort with the default meal at the end

    @meals.sort{ |a,b|
      if a.type == MealList::DEFAULT_MEAL
        1
      elsif b.type == MealList::DEFAULT_MEAL
        -1
      else
        0
      end }.collect { |m| m.to_pretty }.join( ' + ' )
  end

end

# Restaurant Class which contains the meals that a restaraunt can produce.

class Restaurant < MealList
  # ==== Attributes
  #
  # * +name+ - The name of Restaurant
  # * +rank+ - The rank of Restaurant out of 5
  #
  attr_accessor 'name', 'rank'

  def initialize(name, rank)
    @name = name
    @rank = rank
    super()
  end

  # Take a REQUEST and attempt to fulfill it with the meals this
  # restaraunt can produce. If nothing can be fulfilled, nil is
  # returned, otherwise REQUEST is reduced by the amount and a
  # Restaurant object is returned with the amount of meals and type to
  # be made.

  def fulfill(request)
    order = nil

    # iterate over all the meals we can produce and create a Re

    @meals.each do |meal|
      amount = [meal.quantity, request.howmany(meal.type)].min

      if amount > 0
        meal.quantity -= amount
        request.decrease(meal.type, amount)

        if order == nil
          order = Restaurant.new(@name, @rank)
        end

        order.addmeal(Meal.new(meal.type, amount))

      end
    end

    return order
  end

  def to_s
    "#{self.class.name}( #{@name}, #{super})"
  end

end

# The class that represents the requested meals and type

class RequestList < MealList

  # Return whether the meal list is completely fulfillled

  def complete
    @meals.all? { |x| x.quantity == 0 }
  end

end

# The collection class of Restaurants

class RestaurantList
  def initialize
    @establishments = []
  end

  # Add restaraunt to list

  def addRestaurant(theplace)
    @establishments.push(theplace)
  end

  # Attempt to fulfill an order request. An order is returned (it may
  # be partially filled and requestlist needs to be tested).

  def fulfill(requestlist)
    theorder = OrderList.new

    # order establishments by rating (highest to lowest)

    @establishments = @establishments.sort{ |a , b| b.rank <=> a.rank }

    # iterate over the restaraunts attempting to fulfill the request

    @establishments.each do |rest|
      tmp = rest.fulfill(requestlist)
      if tmp != nil
        theorder.addRestaurant(tmp)
      end

      # finish early if we have fullfilled the order completely

      break if requestlist.complete
    end

    return theorder
  end

  def to_s
    if @establishments.length > 0
      "  " + @establishments.join( "\n  ") + "\n"
    else
      ""
    end
  end
end

# Class containing the fulfilled meal order (consisting of the number
# and type of meals for each Restaurant)

class OrderList < RestaurantList

  def initialize
    super
  end

  def to_s
    if @establishments.length > 0
      "The order\n  " + @establishments.join( "\n  ") + "\n"
    else
      ""
    end
  end

  # better output of order

  def to_pretty
    if @establishments.length > 0
      "Expected meal orders: " + @establishments.collect { |m| "Restaurant #{m.name} (#{m.to_pretty})"}.join( ", ")
    else
      ""
    end
  end
end
