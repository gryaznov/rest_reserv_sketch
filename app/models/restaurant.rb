# frozen_string_literal: true

class Restaurant < ApplicationRecord
  include TimeHelper

  has_many :tables

  def opens_at(date)
    date_with_time_as_i date, opening_time
  end

  def closes_at(date)
    result = date_with_time_as_i date, closing_time

    after_midnight?(opening_time, closing_time) ? move_to_next_date(result) : result
  end
end
