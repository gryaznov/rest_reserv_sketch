# frozen_string_literal: true

module TimeHelper
  def date_with_time_as_i(date, time_string)
    (date.to_time + Time.parse(time_string).seconds_since_midnight.seconds).to_i
  end

  def after_midnight?(hours_start, hours_finish)
    Time.parse(hours_finish) < Time.parse(hours_start)
  end

  def move_to_next_date(time_in_seconds)
    time_in_seconds + 24.hours.seconds
  end
end
