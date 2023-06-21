class ReservationsSerializer < ApplicationSerializer
  def self.as_json(reservations)
    reservations.as_json(
      include: %i[
        room
      ]
    )
  end

  def self.collection_as_json(reservations)
    paginated_json(reservations, json_options: {
      include: %i[
        room
      ]
    })
  end
end
