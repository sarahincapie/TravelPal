module ExpensesHelper

	def trip_select
  current_user.trips.all.map {|trip| [trip.name, trip.id]}
end
end
