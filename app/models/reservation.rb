# frozen_string_literal: true

class Reservation < ApplicationRecord
  include TimeHelper

  STEP = 30.minutes.seconds

  belongs_to :user
  belongs_to :table

  delegate :restaurant, to: :table

  validates :from, presence: true
  validates :till, presence: true
  validates :date, presence: true
  validate :from_and_till_correctness

  def from_and_till_correctness
    errors.add(:base, 'should match restaurant schedule') if does_not_match_restaurant_schedule?
    errors.add(:base, 'already reserved') if overlapping_with_another_reservation?
  end

  def does_not_match_restaurant_schedule?
    from < restaurant.opens_at(date) || till > restaurant.closes_at(date)
  end

  def overlapping_with_another_reservation?
    table.reservations
         .where(date: date)
         .where(
            '("reservations"."from" BETWEEN ? AND ?) OR ("reservations"."till" BETWEEN ? AND ?)',
            from, till - 1, from + 1, till
         ).exists?
  end

  def calculate_till(till, steps)
    if till.match?(/\A[0-2][0-9]:(0|3)0\z/)
      result = date_with_time_as_i(date, till)
      from > result ? move_to_next_date(result) : result
    else
      from + steps * STEP
    end
  end
end
