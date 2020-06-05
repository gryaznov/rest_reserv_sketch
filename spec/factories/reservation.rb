# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    date { Date.new(2020, 6, 6) }
    from { 1586161800 }
    till { 1586165400 }
    table
    user
  end
end
