# frozen_string_literal: true

class Table < ApplicationRecord
  include TimeHelper

  belongs_to :restaurant
  has_many :reservations

  validates :number, uniqueness: { scope: :restaurant }

  def reserve_for(user:, date:, from:, till: '', steps: 1)
    reservation = Reservation.new
    reservation.table = self
    reservation.user = user
    reservation.date = date
    reservation.from = date_with_time_as_i(date, from)
    reservation.till = reservation.calculate_till(till, steps)
    reservation.save!
  end
end
