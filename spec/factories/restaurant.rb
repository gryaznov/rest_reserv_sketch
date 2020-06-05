# frozen_string_literal: true

FactoryBot.define do
  factory :restaurant do
    title { 'Krusty Krab' }
    opening_time { '11:30' }
    closing_time { '02:00' }
  end
end
